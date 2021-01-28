#!/bin/sh
# Settings
DEBIAN_TAG=10.7-slim
DEBIAN_DIGEST=sha256:a5edb9fa5b2a8d6665ed911466827734795ef10d2b3985a46b7e9c7f0161a6b3
FREESWITCH_VERSION=1.10.5~release~17~25569c1631~buster-1~buster+1
FREESWITCH_SHORT_VERSION=$(echo "$FREESWITCH_VERSION" | cut -d '~' -f 1)
FUSIONPBX_VERSION=2ea3d8a62a7a7cad2442dcda73cd1021514d5b13
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
done
