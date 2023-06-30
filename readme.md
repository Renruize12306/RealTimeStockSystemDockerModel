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
