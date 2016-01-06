#!/bin/bash

if [ -n "$DEBUG" ]; then
    docker-compose -f docker-compose.test.yml build && \
    docker-compose -f docker-compose.test.yml run -e DEBUG_LOOP=$DEBUG_LOOP sut
else
    time docker run --rm -it \
        --privileged \
        --volumes-from builder_cache \
        -v $(pwd):/app \
        tutum/builder
fi;
