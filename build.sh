#!/bin/sh
set -e
# Settings
DEBIAN_TAG=10.8
DEBIAN_DIGEST=sha256:7f5c2603ccccb7fa4fc934bad5494ee9f47a5708ed0233f5cd9200fe616002ad
FREESWITCH_VERSION=1.10.5~release~17~25569c1631~buster-1~buster+1
FREESWITCH_SHORT_VERSION=$(echo "$FREESWITCH_VERSION" | cut -d '~' -f 1)
FUSIONPBX_VERSION=3c10002d012a4b0929cb1cd8abc5a16297260b39
FUSIONPBX_VERSION_SHORT=$(echo "$FUSIONPBX_VERSION" | head -c 7)
# Build
docker build \
  --build-arg DEBIAN_TAG=1${DEBIAN_TAG} \
  --build-arg DEBIAN_DIGEST=${DEBIAN_DIGEST} \
  --build-arg FREESWITCH_VERSION=${FREESWITCH_VERSION} \
  --build-arg FUSIONPBX_VERSION=${FUSIONPBX_VERSION} \
  --tag fusionpbx:latest \
  FusionPBX
# Tag
for tag in \
  "latest" \
  "fusionpbx-${FUSIONPBX_VERSION}" \
  "fusionpbx-${FUSIONPBX_VERSION}-freeswitch-${FREESWITCH_SHORT_VERSION}" \
  "fusionpbx-${FUSIONPBX_VERSION}-freeswitch-${FREESWITCH_SHORT_VERSION}-debian-${DEBIAN_TAG}" \
  "fusionpbx-${FUSIONPBX_VERSION_SHORT}" \
  "fusionpbx-${FUSIONPBX_VERSION_SHORT}-freeswitch-${FREESWITCH_SHORT_VERSION}" \
  "fusionpbx-${FUSIONPBX_VERSION_SHORT}-freeswitch-${FREESWITCH_SHORT_VERSION}-debian-${DEBIAN_TAG}"
do
  echo "Tagging ${tag}"
  docker tag fusionpbx:latest "fusionpbx:${tag}"
  if [ -n "${DOCKER_REPO}" ] && [ -n "${DOCKER_USER}" ] && [ -n "${DOCKER_PASS}" ]; then
    docker login -u "${DOCKER_USER}" -p "${DOCKER_PASS}" "${DOCKER_REPO}"
    docker tag fusionpbx:latest "${DOCKER_REPO}/fusionpbx:${tag}"
    docker push "${DOCKER_REPO}/fusionpbx:${tag}"
  fi
done
