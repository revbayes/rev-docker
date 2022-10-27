#!/bin/bash

# assume you are in a directory that contains a working RevBayes script
# e.g. you are located in `~/projects/test_job` and want to execute `run_job.Rev`

# User provides script name in local directory
SCRIPT_NAME="$1"

# User can provide Docker container name
CONTAINER_NAME="$2"

# This is where we mount the volume inside the Docker container filesystem
MOUNT_PATH="/mnt/project"

# This construct the volume mount string for Docker
VOLUME_STR="$(pwd):${MOUNT_PATH}"

# Create a contained from this RevBayes-enabled Docker image:tag
IMAGE_STR="sswiston/rb_tp:latest"

# Construct the RevBayes command string (binary followed by source script)
RB_STR="rb ${MOUNT_PATH}/${SCRIPT_NAME}"

# Verify that local script exists
if [[ ! -f "${SCRIPT_NAME}" ]]; then
    echo "ERROR: $(pwd)/${SCRIPT_NAME} not found"
	exit 1
fi

# Construct docker run command string
CMD_STR="docker run "
if [[ -n ${CONTAINER_NAME} ]]; then
	CMD_STR="${CMD_STR} --name ${CONTAINER_NAME}"
fi
CMD_STR="${CMD_STR} --volume ${VOLUME_STR} ${IMAGE_STR} ${RB_STR}"

# Execute docker run command string
echo "Executing \"${CMD_STR}\""
eval ${CMD_STR}
