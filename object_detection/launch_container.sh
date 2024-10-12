nvidia-docker run -v $(pwd):/workspace -v /raid/data/object_detection/datasets/:/datasets -t -i --rm --gpus 1 --ipc=host mlperf/object_detection
