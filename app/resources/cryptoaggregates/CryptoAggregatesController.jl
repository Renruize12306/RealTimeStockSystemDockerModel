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
    json(Dict("crypto_aggregates" => crypto_aggregates))
  end
end

# for testing
# http://127.0.0.1:8000/crypto_aggregates/get_all_by_en_pair?ev_pair=XA_BTC-USD