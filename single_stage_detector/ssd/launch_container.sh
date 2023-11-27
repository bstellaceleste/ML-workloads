docker run --cpuset-cpus="12-15" --cpus="4" --rm -it \
  --gpus=all \
  --ipc=host \
  -v /raid/data/ssd/:/datasets/open-images-v6-mlperf \
  mlperf/single_stage_detector bash
