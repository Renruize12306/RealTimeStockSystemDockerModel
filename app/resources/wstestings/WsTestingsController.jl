module WsTestingsController

using Genie.Renderer.Json, Genie.Router

  function test_ws()
    json(Dict("test_JSON" => "$(params(:payload))"))
  end

  function test_my_chnl()
    @info "Received: $(params(:payload))"
  end

  function test_display()
    json = Dict("test_JSON" => "$(params(:payload))")
    # str_json = String(json)
    @info "We receive the following $json"
    # json("str_json")
    # json(Dict("movies" => "MARVEL"))
  end
end
