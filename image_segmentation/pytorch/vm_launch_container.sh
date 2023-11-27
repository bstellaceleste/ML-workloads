docker run --cpuset-cpus="12-15" --cpus="4" --memory=7g --memory-swap=7g --memory-swappiness=0 --gpus '"device=1"' --ipc=host --rm --runtime=nvidia -it \
        -v /raid/data/imseg/raw-data/kits19/data:/raw-data \
        -v /raid/data/imseg/raw-data/kits19/preproc-data:/data \
	-v /home/stellab/training_git/wklds_colocation:/results  unet3d:imgseg /bin/bash #taskset -ac 0-39 train.sh $2

# --memory=4g --memory-swap=8g --memory-swappiness=100
# --memory=8g --memory-swap=8g --memory-swappiness=0
# $(pwd)/results_vm
