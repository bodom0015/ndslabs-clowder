#!/bin/sh
#
# Usage ./build.sh <tagName>
#
# Latest stable tag: 0.9.2

IMAGES=(clowder toolserver)
EXTRACTORS=(image-preview video-preview plantcv image-metadata audio-preview audio-speech2text pdf-preview)

TAG=$1
if [[ "$1" == "" ]]; then
	TAG=latest
fi

# Build up all of our images from source
for i in "${IMAGES[@]}"; do
	docker build -t ndslabs/$i:${TAG} $i
done

for i in "${EXTRACTORS[@]}"; do
	docker build -t ndslabs/$i:${TAG} extractors/$i
done

# Temporary hack to get this image working
docker tag ndslabs/toolserver:${TAG} ncsa/clowder-toolserver:latest

if [[ "${@/-p/}" != "$@" ]]; then
	for i in "${IMAGES[@]}"; do
		echo docker push ndslabs/$i:${TAG}
	done

	for i in "${EXTRACTORS[@]}"; do
		echo docker push ndslabs/$i:${TAG}
	done
fi
