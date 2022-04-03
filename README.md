# Buildx packaging

[![Build Status](https://img.shields.io/github/workflow/status/crazy-max/buildx-packaging/build?label=build&logo=github)](https://github.com/crazy-max/buildx-packaging/actions?query=workflow%3Abuild)
[![Docker Pulls](https://img.shields.io/docker/pulls/crazymax/buildx-packaging.svg?logo=docker)](https://hub.docker.com/r/crazymax/buildx-packaging/)

This repository creates packages (apk, deb, rpm, static) for [buildx](https://github.com/docker/buildx)
that will be pushed on [`docker/buildx-pkg` Docker Hub repository](https://hub.docker.com/r/docker/buildx-pkg). 

## Usage

```shell
# create packages for the current platform
$ docker buildx bake pkg

# create packages for all supported platforms defined in the HCL definition
$ docker buildx bake pkg-cross

# create debian package for debian11 release and against the current platform
$ PKG_TYPES=deb PKG_DEB_RELEASES=debian11 docker buildx bake pkg

# create packages for windows/amd64 platform and output to ./bin folder
$ docker buildx bake --set *.platform=windows/amd64 --set *.output=./bin pkg

# create packages for all supported platforms and push to crazymax/buildx-pkg:latest
$ docker buildx bake --set *.output=type=image,push=true --set *.tags=crazymax/buildx-pkg:latest pkg-cross
```

## Extract packages

You can use a tool like [Undock](https://github.com/crazy-max/undock) to extract
all packages with:

```shell
$ undock --wrap --rm-dist --all crazymax/buildx-pkg:latest ./bin
$ tree ./bin
./dist/
├── darwin
│   ├── amd64
│   │   └── docker-buildx-plugin_0.8.1.tgz
│   └── arm64
│       └── docker-buildx-plugin_0.8.1.tgz
├── linux
│   ├── amd64
│   │   ├── docker-buildx-plugin-0.8.1-centos7.x86_64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-centos8.x86_64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora33.x86_64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora34.x86_64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora35.x86_64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora36.x86_64.rpm
│   │   ├── docker-buildx-plugin_0.8.1-debian10_amd64.deb
│   │   ├── docker-buildx-plugin_0.8.1-debian11_amd64.deb
│   │   ├── docker-buildx-plugin_0.8.1-r0_x86_64.apk
│   │   ├── docker-buildx-plugin_0.8.1-raspbian10_amd64.deb
│   │   ├── docker-buildx-plugin_0.8.1-raspbian11_amd64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu1804_amd64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2004_amd64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2110_amd64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2204_amd64.deb
│   │   └── docker-buildx-plugin_0.8.1.tgz
│   ├── arm
│   │   ├── v6
│   │   │   ├── docker-buildx-plugin-0.8.1-centos7.armv6hl.rpm
│   │   │   ├── docker-buildx-plugin-0.8.1-centos8.armv6hl.rpm
│   │   │   ├── docker-buildx-plugin-0.8.1-fedora33.armv6hl.rpm
│   │   │   ├── docker-buildx-plugin-0.8.1-fedora34.armv6hl.rpm
│   │   │   ├── docker-buildx-plugin-0.8.1-fedora35.armv6hl.rpm
│   │   │   ├── docker-buildx-plugin-0.8.1-fedora36.armv6hl.rpm
│   │   │   ├── docker-buildx-plugin_0.8.1-debian10_armel.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-debian11_armel.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-r0_armhf.apk
│   │   │   ├── docker-buildx-plugin_0.8.1-raspbian10_armel.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-raspbian11_armel.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-ubuntu1804_armel.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-ubuntu2004_armel.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-ubuntu2110_armel.deb
│   │   │   └── docker-buildx-plugin_0.8.1-ubuntu2204_armel.deb
│   │   ├── v6docker-buildx-plugin_0.8.1.tgz
│   │   ├── v7
│   │   │   ├── docker-buildx-plugin-0.8.1-centos7.armv7hl.rpm
│   │   │   ├── docker-buildx-plugin-0.8.1-centos8.armv7hl.rpm
│   │   │   ├── docker-buildx-plugin-0.8.1-fedora33.armv7hl.rpm
│   │   │   ├── docker-buildx-plugin-0.8.1-fedora34.armv7hl.rpm
│   │   │   ├── docker-buildx-plugin-0.8.1-fedora35.armv7hl.rpm
│   │   │   ├── docker-buildx-plugin-0.8.1-fedora36.armv7hl.rpm
│   │   │   ├── docker-buildx-plugin_0.8.1-debian10_armhf.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-debian11_armhf.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-r0_armv7.apk
│   │   │   ├── docker-buildx-plugin_0.8.1-raspbian10_armhf.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-raspbian11_armhf.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-ubuntu1804_armhf.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-ubuntu2004_armhf.deb
│   │   │   ├── docker-buildx-plugin_0.8.1-ubuntu2110_armhf.deb
│   │   │   └── docker-buildx-plugin_0.8.1-ubuntu2204_armhf.deb
│   │   └── v7docker-buildx-plugin_0.8.1.tgz
│   ├── arm64
│   │   ├── docker-buildx-plugin-0.8.1-centos7.aarch64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-centos8.aarch64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora33.aarch64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora34.aarch64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora35.aarch64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora36.aarch64.rpm
│   │   ├── docker-buildx-plugin_0.8.1-debian10_arm64.deb
│   │   ├── docker-buildx-plugin_0.8.1-debian11_arm64.deb
│   │   ├── docker-buildx-plugin_0.8.1-r0_aarch64.apk
│   │   ├── docker-buildx-plugin_0.8.1-raspbian10_arm64.deb
│   │   ├── docker-buildx-plugin_0.8.1-raspbian11_arm64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu1804_arm64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2004_arm64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2110_arm64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2204_arm64.deb
│   │   └── docker-buildx-plugin_0.8.1.tgz
│   ├── ppc64le
│   │   ├── docker-buildx-plugin-0.8.1-centos7.ppc64le.rpm
│   │   ├── docker-buildx-plugin-0.8.1-centos8.ppc64le.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora33.ppc64le.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora34.ppc64le.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora35.ppc64le.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora36.ppc64le.rpm
│   │   ├── docker-buildx-plugin_0.8.1-debian10_ppc64el.deb
│   │   ├── docker-buildx-plugin_0.8.1-debian11_ppc64el.deb
│   │   ├── docker-buildx-plugin_0.8.1-r0_ppc64le.apk
│   │   ├── docker-buildx-plugin_0.8.1-raspbian10_ppc64el.deb
│   │   ├── docker-buildx-plugin_0.8.1-raspbian11_ppc64el.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu1804_ppc64el.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2004_ppc64el.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2110_ppc64el.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2204_ppc64el.deb
│   │   └── docker-buildx-plugin_0.8.1.tgz
│   ├── riscv64
│   │   ├── docker-buildx-plugin-0.8.1-centos7.riscv64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-centos8.riscv64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora33.riscv64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora34.riscv64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora35.riscv64.rpm
│   │   ├── docker-buildx-plugin-0.8.1-fedora36.riscv64.rpm
│   │   ├── docker-buildx-plugin_0.8.1-debian10_riscv64.deb
│   │   ├── docker-buildx-plugin_0.8.1-debian11_riscv64.deb
│   │   ├── docker-buildx-plugin_0.8.1-r0_riscv64.apk
│   │   ├── docker-buildx-plugin_0.8.1-raspbian10_riscv64.deb
│   │   ├── docker-buildx-plugin_0.8.1-raspbian11_riscv64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu1804_riscv64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2004_riscv64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2110_riscv64.deb
│   │   ├── docker-buildx-plugin_0.8.1-ubuntu2204_riscv64.deb
│   │   └── docker-buildx-plugin_0.8.1.tgz
│   └── s390x
│       ├── docker-buildx-plugin-0.8.1-centos7.s390x.rpm
│       ├── docker-buildx-plugin-0.8.1-centos8.s390x.rpm
│       ├── docker-buildx-plugin-0.8.1-fedora33.s390x.rpm
│       ├── docker-buildx-plugin-0.8.1-fedora34.s390x.rpm
│       ├── docker-buildx-plugin-0.8.1-fedora35.s390x.rpm
│       ├── docker-buildx-plugin-0.8.1-fedora36.s390x.rpm
│       ├── docker-buildx-plugin_0.8.1-debian10_s390x.deb
│       ├── docker-buildx-plugin_0.8.1-debian11_s390x.deb
│       ├── docker-buildx-plugin_0.8.1-r0_s390x.apk
│       ├── docker-buildx-plugin_0.8.1-raspbian10_s390x.deb
│       ├── docker-buildx-plugin_0.8.1-raspbian11_s390x.deb
│       ├── docker-buildx-plugin_0.8.1-ubuntu1804_s390x.deb
│       ├── docker-buildx-plugin_0.8.1-ubuntu2004_s390x.deb
│       ├── docker-buildx-plugin_0.8.1-ubuntu2110_s390x.deb
│       ├── docker-buildx-plugin_0.8.1-ubuntu2204_s390x.deb
│       └── docker-buildx-plugin_0.8.1.tgz
└── windows
    ├── amd64
    │   └── docker-buildx-plugin_0.8.1.zip
    └── arm64
        └── docker-buildx-plugin_0.8.1.zip

15 directories, 116 files
```
