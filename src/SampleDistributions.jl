__precompile__(true)

module SampleDistributions

using Distributions
using StatsBase
using NamedTuples

include("utils.jl")
include("sampledistribution.jl")
include("distributionsapi.jl")

end # module
