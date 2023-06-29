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

route("/api/v1/bgbooks", BooksController.API.billgatesbooks_fun)


route("rest_api/echo", method = POST) do
  message = jsonpayload()
  (:echo => (message["message"] * " ") ^ message["repeat"]) |> json
end

route("/rest_api/send") do
  response = HTTP.request("POST", "http://localhost:8000/rest_api/echo", [("Content-Type", "application/json")], """{"message":"hello", "repeat":3}""")

  response.body |> String |> json
end

# ====================WSS====================

Genie.config.websockets_server = true # enable the websockets server

route("/wss_api") do
    Assets.channels_support() *
  """
  <script>
  window.parse_payload = function(payload) {
    console.log('Got this payload: ' + payload);
    document.getElementById("payloadText").textContent = payload;
  }
  </script>
  <p> Hello There </p>
  <p id="payloadText"></p>
  """
end

using RealTimeStockSystemDockerModel.WsTestingsController

channel("/test/chnl", WsTestingsController.test_ws)

channel("/____/your_chnl") do
  @info "Received: $(params(:payload))"
end

channel("/____/my_chnl", WsTestingsController.test_my_chnl)

channel("/____/display", WsTestingsController.test_display)



# ====================MOVIE====================

using RealTimeStockSystemDockerModel.MoviesController
route("/movies", MoviesController.index)

route("/movies/search", MoviesController.search, named = :search_movies)

route("/movies/search_api", MoviesController.search_api)



# ====================CRYPTO====================
using RealTimeStockSystemDockerModel.CryptoAggregatesController

route("/crypto_aggregates/get_all_by_en_pair", CryptoAggregatesController.get_all_by_en_pair)