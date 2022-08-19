// Copyright 2022 buildx-packaging authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "OUTPUT" {
  default = "./bin"
}

# Sets the buildx repo. Will be used to clone the repo at BUILDX_VERSION ref
# to include the README.md and LICENSE for the static package
variable "BUILDX_REPO" {
  default = "https://github.com/docker/buildx.git"
}

# Sets the buildx version to download the binary from GitHub Releases.
variable "BUILDX_VERSION" {
  default = "v0.9.1"
}

# Sets the list of package types to build: apk, deb, rpm and/or static
variable "PKG_TYPES" {
  default = "apk,deb,rpm,static"
}

# Sets the list of apk releases (e.g., r0)
# docker-buildx-plugin_0.8.1-r0_aarch64.apk
variable "PKG_APK_RELEASES" {
  default = "r0"
}

# Sets the list of deb releases (e.g., debian11)
# docker-buildx-plugin_0.8.1-debian11_arm64.deb
variable "PKG_DEB_RELEASES" {
  default = "debian10,debian11,ubuntu1804,ubuntu2004,ubuntu2204,raspbian10,raspbian11"
}

# Sets the list of rpm releases (e.g., centos7)
# docker-buildx-plugin-0.8.1-fedora35.aarch64.rpm
variable "PKG_RPM_RELEASES" {
  default = "centos7,centos8,fedora33,fedora34,fedora35,fedora36"
}

# Sets the vendor/maintainer name (only for linux packages)
variable "PKG_VENDOR" {
  default = "Docker"
}

# Sets the name of the company that produced the package (only for linux packages)
variable "PKG_PACKAGER" {
  default = "Docker <support@docker.com>"
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "meta-helper" {
  tags = ["dockereng/buildx-pkg:local"]
}

group "default" {
  targets = ["pkg"]
}

group "validate" {
  targets = ["license-validate"]
}

target "license-validate" {
  dockerfile = "./hack/license.Dockerfile"
  target = "validate"
  output = ["type=cacheonly"]
}

target "license-update" {
  dockerfile = "./hack/license.Dockerfile"
  target = "update"
  output = ["."]
}

# Useful commands for this target
# PKG_TYPES=deb PKG_DEB_RELEASES=debian11 docker buildx bake pkg
# docker buildx bake --set *.platform=windows/amd64 --set *.output=./bin pkg
target "pkg" {
  inherits = ["meta-helper"]
  args = {
    BUILDX_REPO = BUILDX_REPO
    BUILDX_VERSION = BUILDX_VERSION
    PKG_TYPES = PKG_TYPES
    PKG_APK_RELEASES = PKG_APK_RELEASES
    PKG_DEB_RELEASES = PKG_DEB_RELEASES
    PKG_RPM_RELEASES = PKG_RPM_RELEASES
    PKG_VENDOR = PKG_VENDOR
    PKG_PACKAGER = PKG_PACKAGER
  }
  target = "pkg"
  platforms = ["local"]
}

# Useful commands for this target
# docker buildx bake pkg-cross --set *.output=type=image,push=true --set *.tags=dockereng/buildx-pkg:latest
target "pkg-cross" {
  inherits = ["pkg"]
  platforms = [
    "darwin/amd64",
    "darwin/arm64",
    "linux/amd64",
    "linux/arm/v6",
    "linux/arm/v7",
    "linux/arm64",
    "linux/ppc64le",
    "linux/riscv64",
    "linux/s390x",
    "windows/amd64",
    "windows/arm64"
  ]
}
