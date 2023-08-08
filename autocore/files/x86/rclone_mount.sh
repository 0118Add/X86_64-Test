#!/bin/sh

CONFIG_FILE="/root/.config/rclone/rclone.conf"

# 下面的名称改成你配置的名称，路径需要改成你想要挂载的路径

REMOTE_NAME="aliyunpan:/" 
#配置网盘的名称

MOUNT_DIR="/opt/shujupan/aliyun"
#挂载硬盘到本地的目录

CACHE_DIR="/opt/shujupan/aliyuntmp"
#缓存目录(空间越大越好)


#以下不需要修改
if grep -qs "$MOUNT_DIR" /proc/mounts; then
    echo "阿里云已挂载"
    exit 0
fi

if [ ! -d "$MOUNT_DIR" ]; then
    mkdir -p "$MOUNT_DIR" && echo "自动创建挂载目录: $MOUNT_DIR"
fi

rclone mount $REMOTE_NAME $MOUNT_DIR \
--cache-dir $CACHE_DIR \
--config=$CONFIG_FILE \
--allow-other \
--allow-non-empty \
--vfs-cache-mode writes &

echo "阿里云挂载成功"

exit 0