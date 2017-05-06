#!/usr/bin/env bash

DEFAULT_SIZE=20M

if [ -z ${UPLOAD_MAX_FILESIZE+false} ]
then
    echo "Using default max upload size: ${DEFAULT_SIZE}"
else
    echo "Using max upload size: ${UPLOAD_MAX_FILESIZE}"
    
    # set size in nginx
    perl -pi -e "s/client_max_body_size(\s*)${DEFAULT_SIZE};/client_max_body_size\${1}${UPLOAD_MAX_FILESIZE};/" /etc/nginx/conf.d/nuget.conf
    
    # set size in php.ini
    perl -pi -e "s/upload_max_filesize = ${DEFAULT_SIZE}/upload_max_filesize = ${UPLOAD_MAX_FILESIZE}/" /etc/hhvm/php.ini
    perl -pi -e "s/post_max_size = ${DEFAULT_SIZE}/post_max_filesize = ${UPLOAD_MAX_FILESIZE}/" /etc/hhvm/php.ini
fi
