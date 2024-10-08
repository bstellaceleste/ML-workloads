docker run --rm -it \
  --gpus=all \
  --ipc=host \
  -v /datasets/ssd/open-images-v6-mlperf/:/datasets/open-images-v6-mlperf/ \
  mlperf/single_stage_detector:stella bash
