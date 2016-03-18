#!/bin/bash
# 
# Usage: ./start-clowder.sh [plugin1] [plugin2] [plugin3]
# 
# Valid plugins:
#     elasticsearch
#     image-preview
#     video-preview
#     plantcv
# 
# Exit on error?
# set -e

start_rc_wait ()
{
 echo ""
 echo Starting controller $1

 if ! kubectl get rc | grep "^$1"; then
   echo "Creating rc for $1"
   kubectl create -f $2
 fi

 sleep 5
 pod=`kubectl get pods | grep "^$1" | awk '{print $1}'`

 status=`kubectl get pod/$pod -o go-template="{{range .status.conditions}}{{if eq .type \"Ready\" }}{{.status}}{{end}}{{end}}"`
 if [ "$status" != 'True' ]; then

   i=0
   while [ "$status" != 'True' ]; do
       echo "Waiting for $1 (Ready=$status)"
       status=`kubectl get pod/$pod -o go-template="{{range .status.conditions}}{{if eq .type \"Ready\" }}{{.status}}{{end}}{{end}}"`
       sleep 10
       ((i++))
       if [ $i == 30 ]; then
           echo "Problem starting $1"
           exit 1
       fi
   done
 fi
 echo "Service $1 (Ready=$status)"

 echo ""
}

# Create required services first
# This will inject environment variables for each into any pods started after the service
echo "Allocating service IPs..."
kubectl create -f services/clowder-svc.yaml
kubectl create -f services/mongo-svc.yaml

echo "Starting MongoDB..."

# Now create our first phase of replication controllers (which will create some pods)
start_rc_wait "mongo" "controllers/mongo-rc.yaml"

REQ_ES="elasticsearch"
REQ_RABBITMQ=(plantcv image-preview video-preview)
OPTIONAL_PLUGINS=(plantcv image-preview video-preview elasticsearch)

# Check for optional plugin with no dependencies (elasticsearch)
if [[ "${@/#$REQ_ES/ }" != "$@" ]] ; then
	echo "Starting elasticsearch..."
	kubectl create -f services/elasticsearch-svc.yaml
fi

# Check for optional plugins that would require RabbitMQ (extractors: image-preview, video-preview, plantcv, etc) 
for i in "${REQ_RABBITMQ[@]}"; do
	if [[ "$RABBIT_ENABLED" != "true" && ( "${@/#$i/ }" != "$@" ) ]]; then
		echo "Extractors require RabbitMQ... Starting RabbitMQ..."
		kubectl create -f services/rabbitmq-svc.yaml
		start_rc_wait "rabbitmq" "controllers/rabbitmq-rc.yaml"
		break
	fi
done

# Now enable the requested optional controllers
for i in "$@"; do
	if [[ ( "${@/#$i/ }" != "$@" ) ]]; then
		echo "Starting $i..."
		start_rc_wait "$i" "controllers/$i-rc.yaml"
	else
		echo "Skipping unrecognized plugin: $i"
	fi
done

# Now start clowder itself
echo "Starting Clowder..."
start_rc_wait "clowder" "controllers/clowder-rc.yaml"
