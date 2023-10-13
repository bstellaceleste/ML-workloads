#!/bin/bash

TERABYTE_PROC_DIR="/raid/data/dlrm/terabyte_mmap_bin"

# Default output dir will be where this script is located
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")
OUTPUT_DIR="/raid/data/dlrm/run_output"
mkdir -p $OUTPUT_DIR

num_gpus=${1:-2}
container_name=${2:-train_dlrm}
IMAGE_NAME=${3:-dlrm:instrumented}
BATCH_SIZE=${4:-2048}
BATCH_SIZE_EVAL=${5:-16384}
NUM_BATCHES=${6:-32768}
NUM_BATCHES_EVAL=${7:-2048}
# NUM_BATCHES=20

# Use this to pass stuff like --enable-profiling
# extra_opts="--enable-profiling"
extra_opts=""

docker run -it --rm \
    --gpus $num_gpus \
    --name $container_name \
    -v $TERABYTE_PROC_DIR:/proc_data \
    -v $OUTPUT_DIR:/code/output \
    $IMAGE_NAME /bin/bash 

