#!/bin/sh

docker run -d --runtime=habana -p 31090:22 
-e HABANA_VISIBLE_DEVICES=all
-e OMPI_MCA_btl_vader_single_copy_mechanism=none 
-v /mnt/hf_cache:/root/.cache/huggingface/hub 
--cap-add=sys_nice 
--ipc=host 
--name vllm-ALL 
-e http_proxy=$http_proxy -e HTTP_PROXY=$HTTP_PROXY -e https_proxy=$https_proxy
-e HTTPS_PROXY=$HTTPS_PROXY -e no_proxy=$no_proxy -e NO_PROXY=$NO_PROXY
-e HUGGING_FACE_HUB_TOKEN=$HUGGING_FACE_HUB_TOKEN
vault.habana.ai/gaudi-docker/1.20.1/ubuntu24.04/habanalabs/pytorch-installer-2.6.0:latest 
sh -c "
apt-get update; 
apt-get install;
sudo openssh-server -y; 
usermod --password '$(echo $PASSWORD | openssl passwd -1 -stdin)' root;
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config;
ssh-keygen -A; service ssh --full-restart; 
echo 'https_proxy=$http_proxy' >> /etc/environment; 
echo 'http_proxy=$https_proxy' >> /etc/environment;
echo 'no_proxy=127.0.0.1,localhost' >> /etc/environment; 
git clone https://github.com/huggingface/optimum-habana; 
git clone https://github.com/HabanaAI/DeepSpeed; 
cd optimum-habana; pip install .; cd ../DeepSpeed; pip install .; cd ..; 
git clone https://github.com/HabanaAI/vllm-fork.git && 
cd vllm-fork; pip install -e .; 
sleep infinity
"