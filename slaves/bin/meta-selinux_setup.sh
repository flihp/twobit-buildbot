#!/bin/sh

CORES_TWICE=$(($(nproc)*2))
SLAVE_ROOT=/var/lib/buildbot/slaves
SELINUX_BUILD=${SLAVE_ROOT}/meta-selinux/build/
SELINUX_AUTO_CONF=${SELINUX_BUILD}/conf/auto.conf
SELINUX_FETCH_CONF=${SELINUX_BUILD}/fetch.conf

# set values in bitbake auto builder config file
cat << EOF > ${SELINUX_AUTO_CONF}
DL_DIR ?= "/mnt/openembedded/downloads/"
BB_NUMBER_THREADS ?= "${CORES_TWICE}"
PARALLEL_MAKE ?= "-j ${CORES_TWICE}"
EOF

# set value in fetch config file 
cat << EOF > ${SELINUX_FETCH_CONF}
GIT_MIRROR="file:///var/lib/git"
EOF

