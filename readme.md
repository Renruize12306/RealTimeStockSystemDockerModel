run backend sever locally 
```
bash> git clone "project url"
bash> ./bin/repl
julia> up()
```
build and test docker locally
```
using GenieDeployDocker
GenieDeployDocker.build()
```

deploy to docker

Set up EC2 instance in min memory is t2.small
[this website tells us how to set up EC2 instance for us](https://genieframework.github.io/Genie.jl/dev/guides/Deploying_Genie_Apps_On_AWS.html)
foe the access permission, please type the following command

```
sudo yum update
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
id ec2-user
newgrp docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Now we can verify that our docker was installed and runs successfully


sudo systemctl status docker.service

# Install Git
sudo yum install git -y

# build Docker

sudo docker build -t backend .
sudo docker images 

sudo docker run -p 80:8000 backend
```


```
chmod 400 EC2_new_key_val_pair.pem
```

touch the constant.jl file 
```
AUTH_PARAM="key from polygon"

event_data = "{\"input_json\":[
    {\"action\":\"auth\",\"params\":\"$AUTH_PARAM\"},
    {\"action\":\"subscribe\",\"params\":\"XA.X:BTC-USD\"}
    ]}"
```

test in the docker 
```
http://184.73.80.39:80/wss_api
http://184.73.80.39:80/crypto_aggregates/initiate_subscription?ticker_to_subscribe=BTC_USD_test&ticker_to_unsubscribe=TVVSDV_test
http://184.73.80.39:80/crypto_aggregates/get_all_by_en_pair?ev_pair=XA_BTC-USD
```

```
running on server
wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.2-linux-x86_64.tar.gz
tar zxvf julia-1.6.2-linux-x86_64.tar.gz

# edit .bashrc
# ===============================Julia Env Setup============================
export PATH="$PATH:/home/ec2-user/julia-1.6.2/bin"

source ~/.bashrc
```