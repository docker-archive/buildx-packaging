# syntax=docker/dockerfile:1

# Copyright 2022 buildx-packaging authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG LICENSE_TYPE="apache"
ARG LICENSE_COPYRIGHT_HOLDER="buildx-packaging authors"
ARG LICENSE_FILES=".*\(Dockerfile\|\.go\|\.hcl\|\.sh\)"

FROM ghcr.io/google/addlicense:v1.0.0 AS addlicense

FROM alpine:3.15 AS base
WORKDIR /src
RUN apk add --no-cache cpio findutils git

FROM base AS set
ARG LICENSE_TYPE
ARG LICENSE_COPYRIGHT_HOLDER
ARG LICENSE_FILES
RUN --mount=type=bind,target=.,rw \
  --mount=from=addlicense,source=/app/addlicense,target=/usr/bin/addlicense \
  find . -regex "${LICENSE_FILES}" | xargs addlicense -c "${LICENSE_COPYRIGHT_HOLDER}" -l "${LICENSE_TYPE}" \
  && mkdir /out \
  && find . -regex "${LICENSE_FILES}" | cpio -pdm /out

FROM scratch AS update
COPY --from=set /out /

FROM base AS validate
ARG LICENSE_ARGS
ARG LICENSE_FILES
RUN --mount=type=bind,target=. \
  --mount=from=addlicense,source=/app/addlicense,target=/usr/bin/addlicense \
  find . -regex "${LICENSE_FILES}" | xargs addlicense -check ${LICENSE_ARGS}
