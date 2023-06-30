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
  @info "The subscription_helper has been called"
  str = params(:ticker_to_subscribe) * "%%%" * params(:ticker_to_unsubscribe) * "%%%" * string(task) * "is running"

  Json.json(Dict("crypto_aggregates" => str))
end

# ====================WSS API Begins====================
include("../../../constant.jl")
using JSON, WebSockets
function subscription_helper()
  json_data = JSON.parse(String(event_data))
  task = @async open_websocket(json_data["input_json"])
  @info "The async task has been called"
  return task
end

function open_websocket(arr)
  if length(arr) > 1
    uri = "wss://socket.polygon.io/crypto"
    WebSockets.open(uri) do ws
      if isopen(ws)
        write(ws, JSON.json(arr[1]))
      end
      subscribe_data(ws, arr[2:length(arr)])
      @info "The subscribe_data has been called"
    end
  end
end
include("CryptoAggregatesProcessor.jl")
function subscribe_data(ws, arr)
  for i in eachindex(arr)
      print(arr[i],"\n")
      write(ws, JSON.json(arr[i]))
  end
  # count the data processing time
  counter = 0
  data_to_save = Vector{Int64}()
  
  while isopen(ws) 
      received_data, success = readguarded(ws)
      if success
          data = String(received_data)
          time_before_processing = Dates.value(now())
          process_websocket_data(data)
          time_after_processing = Dates.value(now())
          print("begin: ", time_before_processing, ", after: ",time_after_processing, ", processing_time: ", time_after_processing - time_before_processing,", \n")
          @info "streamed data" data
          # keep track of processing times
          counter+=1
          append!(data_to_save, time_after_processing - time_before_processing)
      end
  end
  print(data_to_save)
end
# ====================WSS API Ends====================
end

# for testing
# http://127.0.0.1:8000/crypto_aggregates/get_all_by_en_pair?ev_pair=XA_BTC-USD