#!/usr/bin/env bash

if [ -z ${BASE_URL+false} ]
then
	echo "Using base URL: /"
else
	CONFIGFILE=/etc/nginx/conf.d/nuget.conf
	echo "Using base URL: $BASE_URL"
	perl -pi -e "s#rewrite \^(?!$BASE_URL)/#rewrite ^$BASE_URL/#g" $CONFIGFILE
#	perl -pi -e "s#\\\$\\s+(?\$BASE_URL)/#\\\$ $BASE_URL/#g" $CONFIGFILE
	perl -pi -e "s#location = (?!$BASE_URL)/#location = $BASE_URL/#g" $CONFIGFILE
fi
