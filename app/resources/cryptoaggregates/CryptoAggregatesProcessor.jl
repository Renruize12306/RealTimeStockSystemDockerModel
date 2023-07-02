using JSON, Dates, Genie, HTTP

function process_websocket_data(string_data::AbstractString, mgs_chanl::Channel)
    data = JSON.parse(string_data)
    data_single = data[1]
    if "status" in keys(data_single)
        println("states in the key, storage to DDB has been skipped")
        return 
    end
    subscription_type = data_single["ev"]
    subscription_ticker = data_single["pair"]
    if "ev" in keys(data_single)
        delete!(data_single, "ev")
    end
    if "pair" in keys(data_single)
        delete!(data_single, "pair")
    end
    data_single["ev_pair"] = subscription_type * "_" * subscription_ticker
    data_single["create_time"] = Dates.value(now())
    ca_single = CryptoAggregate(ev_pair=data_single["ev_pair"],
    create_time=data_single["create_time"],
    c=data_single["c"], e=data_single["e"], h=data_single["h"],
    l=data_single["l"], o=data_single["o"], s=data_single["s"],
    v=data_single["v"], vw=data_single["vw"],z=data_single["z"])
    time_after_store = Dates.value(now())
    save(ca_single)

    # Broadcast the data to frontend
    Genie.WebChannels.broadcast("____", string_data)
    # Send as websocket message
    if !isempty(mgs_chanl.data)
        take!(mgs_chanl)
    end
    
    put!(mgs_chanl, JSON.json(data_single))

    time_after_notify_frontend = Dates.value(now())
    println("Update frontend_time: ", time_after_notify_frontend - time_after_store)
end