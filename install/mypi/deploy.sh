#! /bin/bash
# build images
echo 'start download code'
myscript=https://raw.githubusercontent.com/daolinhy/myscript/refs/heads/master/

mkdir -p /download/dapp
cd /download/dapp
# 处理mysql redis
echo 'start download database'
if [ ! -e "/download/dapp/mysql5.7" ]; then
    wget ${myscript}install/mypi/app.tar.gz
    tar zxf app.tar.gz
fi
# 处理前后端
mkdir pijs2 hynode-server 
rm .env-sample .ddns-sample.json
if [ ! -e "./hynode-server/.env" ];then
    wget ${myscript}install/mypi/.env-sample
    wget ${myscript}install/mypi/.ddns-sample.json
    cp .ddns-sample.json hynode-server/.ddns.json
    cp .env-sample hynode-server/.env
fi
# 每次更新镜像
docker stop hynode-server-pro pijs2-pro
docker rm hynode-server-pro pijs2-pro
docker rmi swaycn/hynode-server  swaycn/pijs2
# 启动
echo 'start docker'
rm docker-compose.yml
wget ${myscript}install/mypi/docker-compose.yml
docker network create web
docker compose up -d


