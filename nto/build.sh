#!/bin/sh

set -v

REGISTRY=quay.io
ORG=mariofer
repos_dir=./repos        # change this to point to your repos dir (provided in repos.tar.xz)
nto_dir=./cluster-node-tuning-operator

build_push() {
  make -C $nto_dir local-image IMAGE=$IMAGE DOCKERFILE=$DOCKERFILE 
  make -C $nto_dir local-image-push IMAGE=$IMAGE 
}

ocp49_rhel84() {
  local image_tag=4.12

  IMAGE_BUILD_EXTRA_OPTS="-v=$repos_dir/rhel-8.4:/etc/yum.repos.d:z" \
  IMAGE=$REGISTRY/$ORG/cluster-node-tuning-operator:$image_tag \
  DOCKERFILE=Dockerfile.rhel8 \
    build_push
}

#git clone https://github.com/openshift/$nto_dir
ocp49_rhel84
