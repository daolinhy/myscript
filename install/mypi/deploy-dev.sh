#! /bin/bash
# build images
echo 'start download code'
gitAddr=github.com
gitClone=${gitAddr}:daolinhy
myscript=https://raw.githubusercontent.com/daolinhy/myscript/refs/heads/master/

mkdir -p /download/gitspace
cd /download/gitspace
ssh-keygen -R $gitAddr
ssh-keyscan $gitAddr >> ~/.ssh/known_hosts 
if [ ! -e "/download/gitspace/pijs2" ]; then
    echo git@${gitClone}/pijs2.git
    git clone git@${gitClone}/pijs2.git
fi
if [ ! -e "/download/gitspace/hynode-server" ]; then
    echo git@${gitClone}/hynode-server.git
    git clone git@${gitClone}/hynode-server.git
fi
cd pijs2/docker

echo 'start build pijs2'
bash ./deploy-dev.sh

echo 'start build hynode-server'
cd /download/gitspace/hynode-server/docker
bash ./deploy-dev.sh

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
rm docker-compose-dev.yml
wget https://gitee.com/daolin_hy/myscript/raw/master/install/mypi/docker-compose-dev.yml
docker network create web
docker compose -f docker-compose-dev.yml up -d


