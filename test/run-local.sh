#!/bin/sh -e


docker-compose build
docker-compose up --exit-code-from test
