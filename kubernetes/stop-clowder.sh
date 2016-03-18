#!/bin/bash

# If "-m" is specified, keep mongo running
if [[ "${@/#-m/ }" != "$@" ]]; then
	# Stop everything (except MongoDB)
 	kubectl delete -f controllers/tool-srv-rc.yaml
	kubectl delete -f controllers/clowder-rc.yaml
	kubectl delete -f controllers/plantcv-rc.yaml
	kubectl delete -f controllers/image-preview-rc.yaml
	kubectl delete -f controllers/video-preview-rc.yaml
	kubectl delete -f controllers/rabbitmq-rc.yaml
	kubectl delete -f controllers/elasticsearch-rc.yaml

	# Tear down services (except MongoDB)
	kubectl delete -f services/tool-srv-svc.yaml
	kubectl delete -f services/clowder-svc.yaml
	kubectl delete -f services/rabbitmq-svc.yaml 
	kubectl delete -f services/elasticsearch-svc.yaml
else
	# Kill off the controllers first (this brings down the pods)
	kubectl delete -f controllers/

	# Now that the pods are down, we can safely bring down the services
	kubectl delete -f services/
fi
