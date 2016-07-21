#!/bin/sh
# 
# Usage: ./build.sh [-c]
#

# Clean target/ directory if "-c" is specified
if [[ "${@/-c/}" != "$@" ]]; then
	sudo rm -rf target/
fi

# If target/ directory does not exist, run a maven build container to create it
if [[ ! -d "`pwd`/target" ]]; then
	docker run -it --rm -v `pwd`:/workspace -w /workspace maven:3 mvn package
fi

# Finally, build a java image containing the JAR we need to run
docker build -t speech2text .

