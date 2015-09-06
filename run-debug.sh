#!/usr/bin/env bash

docker run --name nuget-server --rm -it -p 80:80 -e "NUGET_API_KEY=secret" simple-nuget-server $@
