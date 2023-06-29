module CryptoAggregates

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export CryptoAggregate

@kwdef mutable struct CryptoAggregate <: AbstractModel
  id::DbId = DbId()
  ev_pair::String = ""
  create_time::Int = 0
  c::Float64 = 0.00
  e::Int = 0
  h::Float64 = 0.00
  l::Float64 = 0.00
  o::Float64 = 0.00
  s::Int = 0
  v::Float64 = 0.00
  vw::Float64 = 0.00
  z::Int = 0
end

end

#= For testing model purposes

using CryptoAggregates

ca_test = CryptoAggregate(ev_pair="XA_BTC-USD",
create_time=63823375562019,
c=30602.28,
e=1687706760000,
h=30604.97,
l=30581.6,
o=30601.1,
s=1687706700000,
v=3.2798317,
vw=30594.2695,
z=0)

save(ca_test)

all(CryptoAggregate)

delete(ca_test)

delete_this = find(CryptoAggregate, id = 1)[end]
delete(delete_this)

=#