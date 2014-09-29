#!/bin/sh

SLAVE_ROOT=/var/lib/buildbot/slaves
CORE_BUILD=${SLAVE_ROOT}/core-image-minimal/build/
CORE_CONF=${CORE_BUILD}/conf/local.conf
CORE_LAYERS=${CORE_BUILD}/LAYERS
CORE_FETCH_CONF=${CORE_BUILD}/fetch.conf

# values we'll be setting in local.conf
DL_DIR="/mnt/openembedded/downloads/"
GIT_MIRROR="file:///var/lib/git"

if [ ! -f ${CORE_CONF} ]; then
    echo "Missing config file for core-image-minimal. Halting."
    exit 1
fi

# set DL_DIR
sed -i "s&^\([[:space:]]*DL_DIR[[:space:]]*\)\(\?=\|\+=\|=\+\|=\).*$&\1\2 \"${DL_DIR}\"&" ${CORE_CONF}
if [ $? -ne 0 ]; then
    exit $?
fi

echo "GIT_MIRROR=\"${GIT_MIRROR}\"" > ${CORE_FETCH_CONF}
if [ $? -ne 0 ]; then
    exit $?
fi

