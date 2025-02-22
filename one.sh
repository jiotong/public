#!/bin/bash

red='\033[0;31m'
plain='\033[0m'
#内网ip地址获取
ip=$(ifconfig|grep 'inet '|grep -v '127.0'|xargs|awk -F '[ :]' '{print $3}')

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}错误: ${plain} 必须使用root用户运行此脚本！\n" && exit 1
cd /opt/ &&
curl -sL https://github.com/jiotong/public/archive/public.tar.gz | tar xz
rm -rf public
mv public-public public
docker stop portainer
docker rm portainer
docker run -d --restart=always --name="portainer" -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -v /opt/public:/public portainer/portainer-ce:2.9.1
echo -e "${red} portainer部署成功，访问 "${ip}":9000"
echo -e "${plain}"
