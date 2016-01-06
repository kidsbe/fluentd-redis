#!/bin/bash

docker-compose -f docker-compose.test.yml build && \
docker-compose -f docker-compose.test.yml run -e DEBUG_LOOP=$DEBUG_LOOP sut
