#!/bin/sh
#
# Usage ./build.sh <tagName> [-p]
#
# Latest stable tag: 0.9.2

IMAGES=(clowder toolserver)
EXTRACTORS=(image-preview video-preview plantcv image-metadata audio-preview speech2text pdf-preview)

TAG=$1
if [[ "$1" == "" || "$1" == "-p" ]]; then
	TAG=latest
fi

# Build up all of our images from source
for i in "${IMAGES[@]}"; do
	docker build -t ndslabs/$i:${TAG} $i
done

for i in "${EXTRACTORS[@]}"; do
	# Use the build script, if one is provided, or perform a raw docker build
	if [[ "$i" == "speech2text" ]]; then
		cd extractors/speech2text/
		sudo sh build.sh
		cd ../..
	else
		docker build -t ndslabs/$i:${TAG} extractors/$i
	fi
done

if [[ "${@/-p/ }" != "$@" ]]; then
	for i in "${IMAGES[@]}"; do
		docker push ndslabs/$i:${TAG}
	done

	for i in "${EXTRACTORS[@]}"; do
		docker push ndslabs/$i:${TAG}
	done
fi
