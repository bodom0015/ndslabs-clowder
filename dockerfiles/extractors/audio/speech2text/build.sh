#!/bin/sh

if [[ "${@/-c/}" != "$@" ]]; then
	sudo rm -rf target/
fi

if [[ ! -d "`pwd`/target" ]]; then
	docker run -it --rm -v `pwd`:/workspace -w /workspace maven:3 mvn package
fi

docker build -t speech2text .
