# Dockerfiles for Clowder
This folder contains everything necessary to build up Clowder's docker images from the base Dockerfiles.

# Images Provided
* image-preview
* video-preview
* plantcv
* clowder
* toolserver

# Building the Images
Simply run the following command to build all images necessary to run the Clowder stack:
~~~
cd dockerfiles/
./build.sh [tagName]
~~~

If no tag name is specified, docker will assume "latest".

You should then see the necessary images being built for you!

NOTE: plantcv can take upwards of ~25 minutes to fully build. Plan accordingly.
