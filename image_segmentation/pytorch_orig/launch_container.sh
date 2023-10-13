docker run --ipc=host --rm --runtime=nvidia -it \
        -v /raid/data/imseg/raw-data/kits19/data:/raw-data \
        -v /raid/data/imseg/raw-data/kits19/preproc-data:/data \
        -v /raid/data/imseg/raw-data/kits19/results:/results  unet3d:rStella /bin/bash
