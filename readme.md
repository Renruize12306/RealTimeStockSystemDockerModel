# AWS EC2 model, streaming the real-time market data -- backend service
This is a backend server of streaming real-time market data, which allows running on either local machine or AWS EC2 instance. For more information in the front end, please refer to repositiory [react_client](https://github.com/Renruize12306/react_client)

## Instructions of running backend services on local machine

Run backend sever in local machine 
```
bash>  git clone "project url"
bash>  ./bin/repl
julia> up()
```
Build and test docker container locally
```
bash>  julia --project=.
julia> using GenieDeployDocker
julia> GenieDeployDocker.build()
```

## Instructions of running backend services on AWS EC2 machine

Set up EC2 instance in min memory is t2.small
[this website provide instructions of how to set up EC2 instance](https://genieframework.github.io/Genie.jl/dev/guides/Deploying_Genie_Apps_On_AWS.html)

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
For the permission issues, please type the following command

```
chmod 400 EC2_new_key_val_pair.pem
```

First, we need to create constant.jl file to configure the some credientails and the ticker we want to subscribe. In this case, aggregate price data for Bitcoin USD using the polygon.io web socket cryptocurrency endpoint.

```
AUTH_PARAM="key from polygon"

event_data = "{\"input_json\":[
    {\"action\":\"auth\",\"params\":\"$AUTH_PARAM\"},
    {\"action\":\"subscribe\",\"params\":\"XA.X:BTC-USD\"}
    ]}"
```

The following link is how to test in the the server, 184.73.80.39 is the public IPV4 for that particular EC2 instance, you can access in the AWS console, 80 is the port number, we mapping the port number 80 outside of the docker to the inside application on the port number 8000.
```
# this are the http request made by the front end.
http://184.73.80.39:80/crypto_aggregates/initiate_subscription?ticker_to_subscribe=place_holder1&ticker_to_unsubscribe=place_holder2
http://184.73.80.39:80/crypto_aggregates/get_all_by_en_pair?ev_pair=XA_BTC-USD
```

Currently, there is there are some issues in mapping the docker websocket port in EC2 instance. Alternately, there is another way of starting backend services, below are the instructions

```
# SSH to the server, installing corresponding julia env
wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.2-linux-x86_64.tar.gz
tar zxvf julia-1.6.2-linux-x86_64.tar.gz

# edit .bashrc
# ===============================Julia Env Setup============================
export PATH="$PATH:/home/ec2-user/julia-1.6.2/bin"

source ~/.bashrc

# then execute the same local deployment as mentioned before.
```