# syntax=docker/dockerfile:1

ARG NFPM_VERSION="2.13.0"
ARG XX_VERSION="1.1.0"

FROM --platform=$BUILDPLATFORM alpine AS base
RUN apk add --no-cache bash curl file git zip tar

FROM base AS src
WORKDIR /src
ARG BUILDX_REPO
ARG BUILDX_VERSION
RUN git clone ${BUILDX_REPO} . && git reset --hard ${BUILDX_VERSION}

FROM base AS download
WORKDIR /download
ARG BUILDX_REPO
ARG BUILDX_VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
RUN <<EOL
set -e
RELEASE_FILENAME="buildx-${BUILDX_VERSION}.$TARGETOS-$TARGETARCH"
if [ -n "$TARGETVARIANT" ]; then
  RELEASE_FILENAME="$RELEASE_FILENAME-$TARGETVARIANT"
fi
RELEASE_EXT=""
if [ "$TARGETOS" = "windows" ]; then
  RELEASE_EXT=".exe"
fi
set -x
wget -q "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/${RELEASE_FILENAME}${RELEASE_EXT}" -qO "buildx"
chmod +x "buildx"
EOL

FROM --platform=$BUILDPLATFORM tonistiigi/xx:${XX_VERSION} AS xx
FROM --platform=$BUILDPLATFORM goreleaser/nfpm:v${NFPM_VERSION} AS nfpm
FROM base AS build-pkg
WORKDIR /work
COPY --from=xx / /
COPY --from=download /download/buildx /usr/bin/buildx
ARG TARGETPLATFORM
ARG BUILDX_VERSION
ARG PKG_TYPES
ARG PKG_APK_RELEASES
ARG PKG_DEB_RELEASES
ARG PKG_RPM_RELEASES
ARG PKG_VENDOR
ARG PKG_PACKAGER
RUN --mount=target=. \
  --mount=from=src,source=/src,target=/buildx-src \
  --mount=from=nfpm,source=/usr/bin/nfpm,target=/usr/bin/nfpm \
  NFPM_CONFIG=./nfpm.yml BUILDX_SRC=/buildx-src OUTPUT=/build ./create-pkg

FROM scratch AS pkg
COPY --from=build-pkg /build /
