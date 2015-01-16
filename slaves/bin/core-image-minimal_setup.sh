#!/bin/sh

SLAVE_ROOT=/var/lib/buildbot/slaves
CORE_BUILD=${SLAVE_ROOT}/core-image-minimal/build/
CORE_AUTO_CONF=${CORE_BUILD}/conf/auto.conf
CORE_FETCH_CONF=${CORE_BUILD}/fetch.conf
CORES_TWICE=$(($(nproc)*2))

# set values in bitbake auto builder config file
cat << EOF > ${CORE_AUTO_CONF}
DL_DIR ?= "/mnt/openembedded/downloads/"
BB_NUMBER_THREADS ?= "${CORES_TWICE}"
PARALLEL_MAKE ?= "-j ${CORES_TWICE}"
EOF

# set value in fetch config file 
cat << EOF > ${CORE_FETCH_CONF}
GIT_MIRROR="file:///var/lib/git"
EOF

