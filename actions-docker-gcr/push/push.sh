#!/bin/bash

set -euo pipefail

: ${GCLOUD_REGISTRY:=us.gcr.io}
: ${IMAGE:=$GITHUB_REPOSITORY}
: ${TAG:=$GITHUB_SHA}
: ${DEFAULT_BRANCH_TAG:=true}
: ${LATEST:=true}

if [ -n "${GCLOUD_SERVICE_ACCOUNT_KEY}" ]; then
  echo ${GCLOUD_SERVICE_ACCOUNT_KEY} | base64 --decode --ignore-garbage > /tmp/key.json
  gcloud auth activate-service-account --quiet --key-file /tmp/key.json
  gcloud auth configure-docker --quiet
else
  echo "GCLOUD_SERVICE_ACCOUNT_KEY was empty, not performing auth, please set a secret in your repo" 1>&2
fi

if [ $LATEST = true ]; then
  docker push $GCLOUD_REGISTRY/$IMAGE:latest
else
  docker push $GCLOUD_REGISTRY/$IMAGE:$TAG
fi