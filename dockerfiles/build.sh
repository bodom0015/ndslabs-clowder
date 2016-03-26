#!/bin/sh
#
# Usage ./build.sh <tagName>
#
# Latest stable tag: 0.9.2

IMAGES=(clowder image-preview video-preview plantcv toolserver)

TAG=$1
if [[ "$1" == "" ]]; then
	TAG=latest
fi

# Build up all of our images from source
for i in "${IMAGES[@]}"; do
	docker build -t ndslabs/$i:${TAG} $i
done

# Temporary hack to get this image working
docker tag ndslabs/toolserver:${TAG} ncsa/clowder-toolserver:latest

if [[ "${@/-p/}" == "$@" ]]; then
	for i in "${IMAGES[@]}"; do
		docker push ndslabs/$i:${TAG}
	done
fi
