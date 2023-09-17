#!/usr/bin/env bash

WORKDIR=$HOME/habitica
CONFIG=$WORKDIR/config
DELETE_AFTER=30 # days
DATE=$(date --iso-8601=hours)
FILENAME=$WORKDIR/habitica-user-data-$DATE.json
PARSED_FILENAME=$WORKDIR/$DATE.json
AUTHOR_ID="52d07da8-722d-499e-896e-837b5a47309f"

if ! [[ -s $CONFIG ]]
then
    not_configured=true
else
    USER_ID=$(awk '/login/ {print $3}' $WORKDIR/config)
    API_KEY=$(awk '/password/ {print $3}' $WORKDIR/config)
    if [[ -z $USER_ID || -z $API_KEY ]]
    then
        not_configured=true
    fi
fi

if [[ $not_configured == "true" ]]
then
    echo "The file $CONFIG needs to contain your userid and api key, get them"
    echo "from https://habitica.com/user/settings/api"
    echo "You can change the directory by editing the WORKDIR variable"
    echo "the file contents should be:"
    echo "login = <your user-id>"
    echo "password = <your api-key>"
    exit 1
fi

if curl --header "x-client: $AUTHOR_ID - Daily Habitica Backup" \
     --header "x-api-user: $USER_ID" \
     --header "x-api-key: $API_KEY" \
     --header "ContentType: application/json" \
     --silent \
     https://habitica.com/export/userdata.json \
    --output $FILENAME
then
    $WORKDIR/habitica.jq $FILENAME > $PARSED_FILENAME
    echo "☑️"
else
	echo "🗙"
fi

# remove old data
find $WORKDIR -name '*.json' -mtime +"${DELETE_AFTER}" -delete