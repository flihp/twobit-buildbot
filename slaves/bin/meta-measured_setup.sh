#!/bin/sh

CORES_TWICE=$(($(nproc)*2))
SLAVE_ROOT=/var/lib/buildbot/slaves
MEASURED_BUILD=${SLAVE_ROOT}/meta-measured/build/
MEASURED_CONF=${MEASURED_BUILD}/conf
MEASURED_AUTO_CONF=${MEASURED_CONF}/auto.conf
MEASURED_FETCH_CONF=${MEASURED_BUILD}/fetch.conf

if [ ! -e ${MEASURED_CONF} ]; then
    mkdir -p ${MEASURED_CONF}
fi

# set values in bitbake auto builder config file
cat << EOL > ${MEASURED_AUTO_CONF}
DL_DIR ?= "/mnt/openembedded/downloads/"
BB_NUMBER_THREADS ?= "${CORES_TWICE}"
PARALLEL_MAKE ?= "-j ${CORES_TWICE}"
EOL

# set value in fetch config file 
cat << EOL > ${MEASURED_FETCH_CONF}
GIT_MIRROR="file:///var/lib/git"
EOL

