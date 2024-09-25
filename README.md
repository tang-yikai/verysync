> 简单易用的多平台文件同步软件，惊人的传输速度是不同于其他产品的最大优势， 微力同步 的智能 P2P 技术加速同步，会将文件分割成若干份仅 KB 的数据同步，而文件都会进行 AES 加密处理。

- 官网：http://verysync.com/
- 论坛：http://forum.verysync.com/forum.php
- 上游代码：https://github.com/jonnyan404/verysync

# 注释
本文中所有尖角括号包含的内容，均需要手动调整

*不要无脑复制粘贴*

*不要无脑复制粘贴*

*不要无脑复制粘贴*

# 1.准备
### 1.1 同步本repo
```bash
git clone https://github.com/tang-yikai/verysync
```
### 1.2 arm64架构，amd64架构跳过
```bash
sed -i 's/amd64/arm64/g' Dockerfile Dockerfile.offline
```
### 1.3 文件解压
```bash
cd files/
tar -xf verysync-*.tar.gz
```

# 2.生成镜像
### 2.1 能访问dockerhub的环境
```bash
podman --cgroup-manager cgroupfs build --tag "<your_tag_name>"  .
```
这里尖角括号代表需要自行修改的容器tag名称，不要使用中文
### 2.2 无法访问dockerhub，或离线环境
```bash
gzip -dc file/busybox-amd64.tar.gz | podman load
podman --file Dockerfile.offline --cgroup-manager cgroupfs build --tag "<your_tag_name>"  .
```
这里尖角括号代表需要自行修改的容器tag名称，不要使用中文

# 3.镜像导入导出
### 导出
```bash
podman save localhost/<自行选择tag名称> --format docker-archive | gzip > <your_archive_name>.tar.gz
```
### 导入
```bash
gzip -dc <archive_name>.tar.gz | podman load
```

# 4. 临时运行
运行容器时，冒号前的端口是主机端口，冒号后的端口是容器内端口
### 4.1 最简单运行
```bash
podman run -d --name verysync \
-p 22330:22330 \
-p 8886:8886 \
localhost/<your_tag_name>
```
* 8886/tcp是WebGUI端口

* 22330/tcp是数据传输TCP端口

* 浏览器打开 <http://IP:8886> 即可访问.
### 4.2 (可选)开放更多端口
```bash
podman run -d --name verysync \
-p 3000:3000 \
-p 22027:22027/udp \
-p 22067:22067/udp \
-p 22330:22330 \
-p 8886:8886 \
localhost/<your_tag_name>
```
* 3000/tcp是微力中继服务默认端口

* 22027/udp是局域网节点IP发现端口

* 22067/udp是中继服务器连接端口
### 4.3 (推荐)数据持久化
```bash
podman run -d --name verysync \
-p 22330:22330 \
-p 8886:8886 \
-v <your_data_path>:/data
-v <verysync_config_path>:/data/.config
localhost/<your_tag_name>
```

# 5.配置为systemd服务
参考链接：

[Make systemd better for Podman with Quadlet](https://www.redhat.com/sysadmin/quadlet-podman)

[与 podman generate systemd 命令相比，使用 Quadlets 的优点](https://docs.redhat.com/zh_hans/documentation/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/advantages-of-using-quadlets-over-the-podman-generate-systemd-command_assembly_porting-containers-to-systemd-using-podman)

从podman4.4开始 podman主线加入了一个功能叫做quadlet，可以简化容器部署，且更易于编写和维护

描述容器的文件，文件名可以修改，后缀名必须为`.container`

示例：`/etc/containers/systemd/verysync.container`

```bash
[Unit]
Description=Verysync container service

[Container]
ContainerName=verysync
Image=localhost/<tag_name>
PublishPort=<your_Host_port1>:8886
PublishPort=<your_Host_port2>:22330
Volume=<your_data_path>:/data
Volume=<verysync_config_path>:/data/.config
Volume=/usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro
HealthCmd=CMD-SHELL nc -z 127.0.0.1 8886 || exit 1
HealthInterval=1m
HealthStartPeriod=15s
HealthTimeout=5s
HealthOnFailure=kill

[Service]
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
生成此文件后，执行
```bash
systemctl daemon-reload
systemctl start verysync.service
```