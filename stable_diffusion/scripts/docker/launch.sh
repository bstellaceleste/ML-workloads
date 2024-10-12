#!/usr/bin/env bash

: "${DST_IMG:=mlperf/stable_diffusion}"

while [ "$1" != "" ]; do
    case $1 in
        -d | --dst-img  )       shift
                                DST_IMG=$1
                                ;;
    esac
    shift
done

docker run --rm -it --gpus=all --ipc=host \
    -e PYTHONPYCACHEPREFIX=/tmp/.pycache \
    --workdir /pwd \
    -v ${PWD}:/pwd \
    -v /raid/data/stable_diffusion/laion-400m:/datasets/laion-400m \
    -v /raid/data/stable_diffusion/coco2014:/datasets/coco2014 \
    -v /raid/data/stable_diffusion/checkpoints:/checkpoints \
    -v /raid/data/stable_diffusion/results:/results \
    ${DST_IMG} bash
