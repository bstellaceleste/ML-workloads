docker run --ipc=host --rm --runtime=nvidia -it \
        -v /raid/data/imseg/raw-data/kits$1/data:/raw-data \
        -v /raid/data/imseg/raw-data/kits$1/preproc-data:/data \
        -v /raid/data/imseg/raw-data/kits$1/results:/results  unet3d:rStella #taskset -ac 0-39 /bin/bash train.sh $2
