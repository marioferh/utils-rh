#!/bin/sh

set -v

REGISTRY=
ORG=
repos_dir=./repos        # change this to point to your repos dir
nto_dir=./cluster-node-tuning-operator

build_push() {
  make -C $nto_dir local-image IMAGE=$IMAGE DOCKERFILE=$DOCKERFILE 
  make -C $nto_dir local-image-push IMAGE=$IMAGE 
}

local image_tag=

IMAGE=$REGISTRY/$ORG/cluster-node-tuning-operator:$image_tag \
DOCKERFILE=Dockerfile \
  build_push

#git clone https://github.com/openshift/$nto_dir
