using Genie.Router, Genie.Assets
using Genie, Genie.Renderer.Json, Genie.Requests
using HTTP

route("/") do
  serve_static_file("welcome.html")
end

route("/hello") do
  "Welcome to Genie!"
end

using RealTimeStockSystemDockerModel.BooksController

#route("/bgbooks", BooksController.billgatesbooks)

route("/api/v1/bgbooks", BooksController.API.billgatesbooks)


route("rest_api/echo", method = POST) do
  message = jsonpayload()
  (:echo => (message["message"] * " ") ^ message["repeat"]) |> json
end

route("/rest_api/send") do
  response = HTTP.request("POST", "http://localhost:8000/rest_api/echo", [("Content-Type", "application/json")], """{"message":"hello", "repeat":3}""")

  response.body |> String |> json
end


Genie.config.websockets_server = true # enable the websockets server

route("/wss_api/") do
    Assets.channels_support() *
  """
  <script>
  window.parse_payload = function(payload) {
    console.log('Got this payload: ' + payload);
  }
  </script>
  """
end

channel("/____/echo") do
    @info "Received: $(params(:payload))"
end