#!/bin/sh

SLAVE_ROOT=/var/lib/buildbot/slaves
CORE_BUILD=${SLAVE_ROOT}/core-image-minimal/build/
CORE_AUTO_CONF=${CORE_BUILD}/conf/auto.conf
CORE_FETCH_CONF=${CORE_BUILD}/fetch.conf

# set values in bitbake auto builder config file
cat << EOF > ${CORE_AUTO_CONF}
DL_DIR ?= "/mnt/openembedded/downloads/"
EOF

# set value in fetch config file 
cat << EOF > ${CORE_FETCH_CONF}
GIT_MIRROR="file:///var/lib/git"
EOF

