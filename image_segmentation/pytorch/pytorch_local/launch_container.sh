docker run --ipc=host --rm -it \
        -v /home/stellab/pytorch/raw-data/kits19/data:/raw-data \
        -v /home/stellab/pytorch/raw-data/kits19/preproc-data:/data \
        -v /home/stellab/pytorch/raw-data/kits19/results:/results  unet3d:expes_start taskset -ac 0-11 /bin/bash train.sh
