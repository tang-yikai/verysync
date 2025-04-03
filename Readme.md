# 微力同步VerySync

 > 简单易用的多平台文件同步软件，惊人的传输速度是不同于其他产品的最大优势， 微力同步 的智能 P2P 技术加速同步，会将文件分割成若干份仅 KB 的数据同步，而文件都会进行 AES 加密处理。
  - 官网：http://verysync.com/
  - 论坛：http://forum.verysync.com/forum.php

---
## 自行编译
`podman build --build-arg ARCH=$(uname -m | sed -e 's/x86_64/amd64/'  -e 's/aarch64/arm64/' -e 's/armv7l/arm/') . -t verysync:test -f Dockerfile.distroless`

*注意：*
*本repo并非官方build*
*从官方下载安装二进制文件*
*部分代码来自https://github.com/ncopa/su-exec*
*部分代码来自https://github.com/https://github.com/Jonnyan404/verysync/*
*使用Google™ Distroless基础镜像重新封装，以规避alpine基础镜像和busybox基础镜像的漏洞*
