#!/usr/bin/env bash

docker run --name nuget --rm -it -p 5005:80 nuget $@
