# using Genie.Router

# channel("/foo/bar") do
#   # process request
# end

# channel("/baz/bax", YourController.your_handler)

using Genie, Genie.Router, Genie.Assets

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

up() # start the servers