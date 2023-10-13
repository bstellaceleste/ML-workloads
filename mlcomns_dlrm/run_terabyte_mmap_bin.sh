
#!/bin/bash

# This is the file that serves as running the dlrm session on docker


BATCH_SIZE=${1:-4096}
BATCH_SIZE_EVAL=${2:-16384}
NUM_BATCHES=${3:-49152} # 32768
NUM_BATCHES_EVAL=${4:-2048}
NUM_WORKERS=${5:-0}
# Use this to send --enable-profiling
EXTRA_OPTS=${6:-""}

# start timing
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)
echo "---Start running dlrm with Terabyte dataset at $start_fmt---"

# Reference run parameters!
python dlrm_s_pytorch.py \
    --arch-sparse-feature-size=128 \
    --arch-mlp-bot="13-512-256-128" \
    --arch-mlp-top="1024-1024-512-256-1" \
    --max-ind-range=40000000 \
    --data-generation=dataset \
    --data-set=terabyte \
    --raw-data-file=/data_terabyte/day \
    --processed-data-file=/proc_data/terabyte_processed.npz \
    --loss-function=bce \
    --round-targets=True \
    --learning-rate=1.0 \
    --mini-batch-size=${BATCH_SIZE} \
    --test-mini-batch-size=${BATCH_SIZE_EVAL} \
    --num-batches=${NUM_BATCHES} \
    --num-batches-eval=${NUM_BATCHES_EVAL} \
    --print-freq=512 \
    --print-time \
    --test-freq=16384 \
    --num-workers=${NUM_WORKERS} \
    --memory-map \
    --mlperf-logging \
    --mlperf-auc-threshold=0.8025 \
    --mlperf-bin-loader \
    --save-model=/code/ckpts/dlrm.ckpt \
    --use-gpu $EXTRA_OPTS 2>&1

# python dlrm_s_pytorch.py \
# --use-gpu \
# --arch-sparse-feature-size=64 \
# --arch-mlp-bot="13-512-256-64" \
# --arch-mlp-top="512-512-256-1" \
# --max-ind-range=10000000 \
# --data-generation=dataset \
# --data-set=terabyte \
# --raw-data-file=/data_terabyte/day \
# --processed-data-file=/proc_data/terabyte_processed.npz \
# --loss-function=bce \
# --round-targets=True \
# --learning-rate=0.1 \
# --mini-batch-size=${BATCH_SIZE} \
# --print-freq=512 \
# --num-batches=${NUM_BATCHES} \
# --print-time \
# --test-freq=1536 \
# --test-mini-batch-size=${BATCH_SIZE} \
# --mlperf-logging \
# --mlperf-bin-loader \
# --mlperf-bin-shuffle \
# --log-file=./output/app.log \
# --memory-map \
# --num-workers=32 \
# --test-num-workers=32 $EXTRA_OPTS 2>&1

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "---End running dlrm at $end_fmt---"

cp /code/dlrm.log ./output/dlrm_tera.log

echo "done"
# report result
result=$(( $end - $start ))
echo "DLRM Training Finished using time: $result"
