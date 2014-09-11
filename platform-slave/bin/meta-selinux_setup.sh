#!/bin/sh

SLAVE_ROOT=/var/lib/buildbot/slaves
SELINUX_BUILD=${SLAVE_ROOT}/meta-selinux/build/
SELINUX_CONF=${SELINUX_BUILD}/conf/local.conf
SELINUX_LAYERS=${SELINUX_BUILD}/LAYERS
SELINUX_FETCH_CONF=${SELINUX_BUILD}/fetch.conf

# values we'll be setting in local.conf
DL_DIR="/mnt/openembedded/downloads/"
GIT_MIRROR="file:///var/lib/git/mirror"

if [ ! -f ${SELINUX_CONF} ]; then
    echo "Missing config file for meta-selinux. Halting."
    exit 1
fi

# set DL_DIR
sed -i "s&^\([[:space:]]*DL_DIR[[:space:]]*\)\(\?=\|\+=\|=\+\|=\).*$&\1\2 \"${DL_DIR}\"&" ${SELINUX_CONF}
if [ $? -ne 0 ]; then
    exit $?
fi

echo "GIT_MIRROR=\"${GIT_MIRROR}\"" > ${SELINUX_FETCH_CONF}
if [ $? -ne 0 ]; then
    exit $?
fi

