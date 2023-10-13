docker run --ipc=host --rm --runtime=nvidia -it \
        -v /raid/data/imseg/raw-data/kits19/data:/raw-data \
        -v /raid/data/imseg/raw-data/kits19/preproc-data:/data \
	-v $(pwd)/results_vm:/results  unet3d:imgseg taskset -ac 0-39 /bin/bash train.sh $2
