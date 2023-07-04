module CryptoAggregatesController
# Build something great
using Genie.Renderer.Json
using Genie, Genie.Renderer, SearchLight, RealTimeStockSystemDockerModel.CryptoAggregates

function get_all_by_en_pair()
  # Get all crypto aggregates by ev pair
  crypto_aggregates = find(CryptoAggregate,
    SQLWhereExpression("ev_pair = ?", params(:ev_pair))
  )

  # Return the crypto aggregates
  Json.json(Dict("crypto_aggregates" => crypto_aggregates))
end

function initiate_subscription()
  # For now, we only allows subscribe one ticker at a time
  task = subscription_helper()
  str = params(:ticker_to_subscribe) * "%%%" * params(:ticker_to_unsubscribe) * "%%%" * string(task) * " is running"

  Json.json(Dict("crypto_aggregates" => str))
end

# ====================WSS API Begins====================
include("../../../constant.jl")
using JSON, HTTP.WebSockets
function subscription_helper()
  json_data = JSON.parse(String(event_data))
  task = @async open_websocket(json_data["input_json"])
  # open_websocket(json_data["input_json"])
  return task
end

function open_websocket(arr)
  if length(arr) > 1
    uri = "wss://socket.polygon.io/crypto"
    WebSockets.open(uri) do ws
      WebSockets.send(ws, JSON.json(arr[1]))
      subscribe_data(ws, arr[2:length(arr)])
    end
  end
end

include("CryptoAggregatesProcessor.jl")
function pub_data(msg_buffer::Vector{String}, msg_chanl::Channel)
  # WebSockets.listen("127.0.0.1", UInt16(8081)) do ws  
  # if test with EC2 please binding with private IPv4 address with terminal 
    WebSockets.listen("172.31.95.69", UInt16(8081)) do ws
      msg_out = ""
      try
          while true
            time_before_notify = Dates.value(now())
              msg_out = take!(msg_chanl)
              while size(msg_buffer, 1) > 0
                  msg_temp = pop!(msg_buffer)
                  send(ws, msg_temp)
                  # println("send msg in vector, ", msg_temp)
              end
              send(ws, msg_out)
              # println("send msg in channel, ", msg_out)
              msg_out = ""
              time_after_notify = Dates.value(now())
              time_consumption = time_after_notify - time_before_notify
              println("Notify frontend: ", time_consumption)
          end
      catch error
          if isa(error, Base.IOError) && error.code == -32
              println("Connection is shut down by the client, re-establish websocket")
              println(error)
              if msg_out != ""
                push!(msg_buffer, msg_out)
              end
          else
              # Unexpected error
              throw(error)
          end
      end
    end
end

function subscribe_data(ws, arr)
  for i in eachindex(arr)
      print(arr[i],"\n")
      WebSockets.send(ws, JSON.json(arr[i]))
  end
  # count the data processing time
  counter = 0
  data_to_save = Vector{Int64}()
  mgs_buffer = Vector{String}()
  mgs_chanl = Channel(1)
  task = @async pub_data(mgs_buffer,mgs_chanl)
  while isopen(ws.io) && counter < 7
      received_data = WebSockets.receive(ws)
      
          data = String(received_data)
          # time_before_processing = Dates.value(now())
          process_websocket_data(data, mgs_chanl, data_to_save)
          # time_after_processing = Dates.value(now())
          # print("begin: ", time_before_processing, ", after: ",time_after_processing, ", processing_time: ", time_after_processing - time_before_processing,", \n")
          # keep track of processing times
          counter+=1
          # append!(data_to_save, time_after_processing - time_before_processing)
      
  end
  print(data_to_save)
end
# ====================WSS API Ends====================
end

# for testing
# http://127.0.0.1:8000/crypto_aggregates/get_all_by_en_pair?ev_pair=XA_BTC-USD