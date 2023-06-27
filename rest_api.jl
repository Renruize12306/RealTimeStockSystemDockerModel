# # rest.jl
# using Genie
# import Genie.Renderer.Json: json

# Genie.config.run_as_server = true

# route("/") do
#   (:message => "Hi there!") |> json
# end

# up()

using Genie, Genie.Renderer.Json, Genie.Requests
using HTTP

route("rest_api/echo", method = POST) do
  message = jsonpayload()
  (:echo => (message["message"] * " ") ^ message["repeat"]) |> json
end

route("/rest_api/send") do
  response = HTTP.request("POST", "http://localhost:8000/echo", [("Content-Type", "application/json")], """{"message":"hello", "repeat":3}""")

  response.body |> String |> json
end

up(async = false)