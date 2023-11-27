TERABYTE_PROC_DIR="/raid/data/dlrm/terabyte_mmap_bin"

# Default output dir will be where this script is located
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")
OUTPUT_DIR="/raid/data/dlrm/run_output"
RESULTS="/home/stellab/training_git/wklds_colocation/dlrm-imseg"
mkdir -p $OUTPUT_DIR

num_gpus=${1:-2}
container_name=${2:-train_dlrm}
IMAGE_NAME=${3:-dlrm:instrumented}

docker run --cpuset-cpus="8-11" --cpus="4" --memory=43g --memory-swap=45g --memory-swappiness=100 -it --rm \
    --gpus $num_gpus \
    --name  $container_name \
    -v $TERABYTE_PROC_DIR:/proc_data \
    -v $OUTPUT_DIR:/code/output \
    -v $RESULTS:/results \
    $IMAGE_NAME /bin/bash

# --memory=41g --memory-swap=45g --memory-swappiness=100
# --memory=45g --memory-swap=45g --memory-swappiness=0
