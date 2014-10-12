#!/bin/sh

if [ ! -d "$1" ]; then
    echo "$0: $1 is not a directory"
    exit 1
fi

find $1 -type d | while read DIR; do
    chmod g+rx "${DIR}"
done
find $1 -type f | while read FILE; do
    chmod g+r "${FILE}"
done
