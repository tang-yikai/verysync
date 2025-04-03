# 微力同步VerySync

 > 简单易用的多平台文件同步软件，惊人的传输速度是不同于其他产品的最大优势， 微力同步 的智能 P2P 技术加速同步，会将文件分割成若干份仅 KB 的数据同步，而文件都会进行 AES 加密处理。
  - 官网：http://verysync.com/
  - 论坛：http://forum.verysync.com/forum.php

---
## 自行编译
`podman build --build-arg ARCH=$(uname -m | sed -e 's/x86_64/amd64/'  -e 's/aarch64/arm64/' -e 's/armv7l/arm/') . -t verysync:test -f Dockerfile.distroless`

## 简单使用

`docker run --name verysync  -d -p 3000:3000 -p 22037:22037/udp -p 22027:22027/udp  -p 22330:22330 -p 8886:8886 jonnyan404/verysync`

- 打开 http://IP:8886 即可访问.

## 进阶使用
**自定义端口**

`docker run --name verysync  -d -p 3000:3000 -p 22037:22037/udp -p 22027:22027/udp -p xxx:xxx -e PORT=yyy -p yyy:yyy jonnyan404/verysync`



- 3000 为默认公共中继端口-(**可选**)
- 22027/22037 为内网udp发现端口-(**可选**)
- xxx 数据传输端口(默认22330)-(**可选**)
- yyy web管理页面端口(默认8886)-(**必须**)

**挂载配置与数据目录**

`docker run --name verysync  -d -v /path/you/dir:/data -p 3000:3000 -p 22037:22037/udp -p 22027:22027/udp -p xxx:xxx -e PORT=yyy -p yyy:yyy jonnyan404/verysync`



- /path/you/dir  替换为你自己的目录(可执行创建命令 mkdir -p /path/you/dir)
- 在web界面指定下载目录为 `/data` 即可下载数据到宿主机的 `/path/you/dir` 目录.

**以 no-root 用户运行**

从 2.16.x 版本开始,
如需自定义用户,请自行定义变量 `VUID` 的值(此值必须为Linux系统已存在的UID值).

*注意：*
*本repo并非官方build*
*从官方下载安装二进制文件*
*部分代码来自https://github.com/ncopa/su-exec*
*部分代码来自https://github.com/https://github.com/Jonnyan404/verysync/*
*使用Google™ Distroless基础镜像重新封装，以规避alpine基础镜像和busybox基础镜像的漏洞*
