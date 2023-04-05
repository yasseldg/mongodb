#!/bin/bash

if [ -n "$MONGO_INITDB_ROOT_USERNAME" ] && [ -n "$MONGO_INITDB_ROOT_PASSWORD" ]; then

    if [ -n "$READ_USERNAME" ] && [ -n "$READ_PASSWORD" ]; then
        echo "=> Creating readAnyDatabase user with a password in MongoDB"
        mongosh admin -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" << EOF
use admin
db.createUser({user: '$READ_USERNAME', pwd: '$READ_PASSWORD', roles:[{role:'readAnyDatabase', db:'admin'}]})
EOF
    fi

    if [ -n "$WRITE_USERNAME" ] && [ -n "$WRITE_PASSWORD" ]; then
        echo "=> Creating a readWriteAnyDatabase user with a password in MongoDB"
        mongosh admin -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" << EOF
use admin
db.createUser({user: '$WRITE_USERNAME', pwd: '$WRITE_PASSWORD', roles:[{role:'readWriteAnyDatabase', db:'admin'}]})
EOF
    fi

    if [  -n "$MONGO_INITDB_DATABASE" ] && [ "$MONGO_INITDB_DATABASE" != "admin" ]; then
        echo "=> Creating a ${MONGO_INITDB_DATABASE} database user with a password in MongoDB"
        mongosh admin -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" << EOF
use $MONGO_INITDB_DATABASE
db.createUser({user: '$MONGO_INITDB_USERNAME', pwd: '$MONGO_INITDB_PASSWORD', roles:[{role:'readWrite', db:'$MONGO_INITDB_DATABASE'}]})
EOF
    fi
fi
