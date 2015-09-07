#!/usr/bin/env bash

if [ -z ${BASE_URL+false} ]
then
	echo "Using base URL: /"
else
	echo "Using base URL: $BASE_URL"
	sed -i /etc/nginx/conf.d/nuget.conf \
		-e "s#rewrite \^/#rewrite ^$BASE_URL/#g" \
		-e "s#location = /#location = $BASE_URL/#g"
fi
