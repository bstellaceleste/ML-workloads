# Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

ARG FROM_IMAGE_NAME=pytorch/pytorch:1.7.0-cuda11.0-cudnn8-runtime
FROM ${FROM_IMAGE_NAME}

RUN apt-get update && \
    apt-get upgrade -y && \
	apt-get install -y git vim

ADD . /code
WORKDIR /code

RUN pip install --ignore-installed -r requirements.txt

RUN git clone https://github.com/mlperf/logging.git mlperf-logging
RUN pip install --ignore-installed -e mlperf-logging

RUN pip install tensorboard
