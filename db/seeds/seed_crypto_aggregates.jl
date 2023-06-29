using SearchLight, RealTimeStockSystemDockerModel.CryptoAggregates
using CSV

Base.convert(::Type{String}, _::Missing) = ""
Base.convert(::Type{Int}, _::Missing) = 0
Base.convert(::Type{Int}, s::String) = parse(Int, s)
Base.convert(::Type{Float64}, s::String) = parse(Float64, s)
Base.convert(::Type{Float64}, _::Missing) = 0.00

function seed()
  for row in CSV.Rows(joinpath(@__DIR__, "crypto_aggregates.csv"), limit = 1_000)
    ca = CryptoAggregate()

    ca.ev_pair = row.ev_pair
    ca.create_time = parse(Int, row.create_time)
    ca.c = parse(Float64, row.c)
    ca.e = parse(Int, row.e)
    ca.h = parse(Float64, row.h)
    ca.l = parse(Float64, row.l)
    ca.o = parse(Float64, row.o)
    ca.s = parse(Int, row.s)
    ca.v = parse(Float64, row.v)
    ca.vw = parse(Float64, row.vw)
    ca.z = parse(Int, row.z)

    save(ca)
  end
end

#=
For testing purposes

include(joinpath("db", "seeds", "seed_crypto_aggregates.jl"))
seed()

=# 
