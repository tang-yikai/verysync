# 微力同步VerySync

  - 官网：http://verysync.com/
  - 论坛：http://forum.verysync.com/forum.php

---
## 自行编译
`podman build --build-arg ARCH=$(uname -m | sed -e 's/x86_64/amd64/'  -e 's/aarch64/arm64/' -e 's/armv7l/arm/') . -t <Put your tag here> -f Dockerfile.distroless`

## 运行镜像
#### 基础版（仅访问WebUI）
`podman run -d <your tag> -p 127.0.0.1:8886:8886`

#### 入门版（访问WebUI和TCP同步端口）
`podman run -d <your tag> -p 127.0.0.1:8886:8886 -p <Your TCP Port>:22330`

#### 进阶版（访问WebUI和TCP，UDP同步端口，并保存同步数据与配置）
`podman run -d <your tag> -p 127.0.0.1:8886:8886 -p <Your TCP Port>:22330 -p <Your UDP Port>:<container UDP Port>/udp -v </Your/Data/Path>:/data -v <Your/Config/Path>:/data/.config`

#### 骨灰版（使用quadlet配置为系统服务）
```
cat /etc/containers/systemd/verysync.container 
[Unit]
Description=Verysync container service

[Container]
ContainerName=verysync
Image=localhost/verysync:<Put Your Tag Here>
PodmanArgs=--memory 768M --cpus 2
PublishPort=127.0.0.1:8886:8886
PublishPort=<Your TCP Port>:22330
PublishPort=<Your UDP port>:<Container UDP Port>/udp
Volume=<Your/Data/Path>:/data
Volume=<Your/Config/Path>:/data/.config

[Service]
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```


*注意：*

*本repo并非官方build，从官方下载安装二进制文件*

*使用Google™ Distroless基础镜像重新封装，以规避alpine基础镜像和busybox基础镜像的漏洞*

*由于Distroless镜像本身不包含任何二进制文件，因此Healthcheck中包含的任何测试命令均无法执行，如有需要可任意自行引入*
