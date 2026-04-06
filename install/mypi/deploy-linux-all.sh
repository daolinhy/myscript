#! /bin/bash
# build images
echo 'start download code'
mkdir -p /download/gitspace
cd /download/gitspace
ssh-keygen -R gitee.com
ssh-keyscan gitee.com >> ~/.ssh/known_hosts 
if [ ! -e "/download/gitspace/pijs2" ]; then
    git clone git@gitee.com:daolin_hy/pijs2.git -o StrictHostKeyChecking=no
fi
if [ ! -e "/download/gitspace/hynode-server" ]; then
    git clone git@gitee.com:daolin_hy/hynode-server.git -o StrictHostKeyChecking=no
fi
cd pijs2/docker

echo 'start build pijs2'
name=pijs2-pro
image=daolin/pijs2
ver=v1
docker stop $name
docker rm $name
docker rmi ${image}:${ver}
docker build -t ${image}:${ver} .

echo 'start build hynode-server'
cd /download/gitspace/hynode-server
cp .env-sample .env
cp .ddns-sample.json .ddns.json
name=hynode-server-pro
image=daolin/hynode-server
ver=v1
mkdir logs
docker stop $name
docker rm $name
docker rmi ${image}:${ver}
docker build -t ${image}:${ver} .

mkdir /download/dapp
cd /download/dapp

# 处理mysql redis
echo 'start download database'
if [ ! -e "/download/dapp/mysql5.7" ]; then
    wget https://gitee.com/daolin_hy/docker/raw/master/install/mypi/app.tar.gz
    tar zxf app.tar.gz
fi
# 启动
echo 'start docker'
rm docker-compose-linux.yml
wget https://gitee.com/daolin_hy/myscript/raw/master/install/mypi/docker-compose-linux.yml
docker network create web
docker compose -f docker-compose-linux.yml up -d


