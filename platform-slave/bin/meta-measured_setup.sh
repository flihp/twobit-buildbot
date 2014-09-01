#!/bin/sh

SLAVE_ROOT=/var/lib/buildbot/slaves
MEASURED_BUILD=${SLAVE_ROOT}/meta-measured/build/
MEASURED_CONF=${MEASURED_BUILD}/conf/local.conf
LOGFILE=${SLAVE_ROOT}

# values we'll be setting in local.conf
DL_DIR="/mnt/openembedded/downloads/"
SSTATE_DIR="/mnt/openembedded/sstate-cache"

if [ ! -f ${MEASURED_CONF} ]; then
    echo "Missing config file for meta-measured. Halting."
    exit 1
fi

# set DL_DIR
sed -i "s&^\([[:space:]]*DL_DIR[[:space:]]*\)\(\?=\|\+=\|=\+\|=\).*$&\1\2 \"${DL_DIR}\"&" ${MEASURED_CONF}
if [ $? -ne 0 ]; then
    exit $?
fi

