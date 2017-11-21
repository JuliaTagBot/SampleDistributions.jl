
struct SampleDistribution{T,K} <: Distribution{Multivariate, Discrete}
    dist::Categorical{T}
    map::Dict{K,Int}
    inverse_map::Dict{Int,K}
end

function SampleDistribution(p::AbstractVector{T}, dict::Dict{K,<:Integer}) where {T<:Real,K}
    SampleDistribution{T,K}(Categorical{T}(p), dict, inversedict(dict))
end

# this is a dict with probabilities as values
function SampleDistribution(dict::Dict{K,T}) where {K,T<:AbstractFloat}
    ks = collect(keys(dict))
    p = getindex.(dict, ks)
    SampleDistribution(p, Dict(ks[i]=>i for i ∈ 1:length(ks)))
end

# this is a dict with counts as values
function SampleDistribution(dict::Dict{K,T}) where {K,T<:Integer}
    total = sum(values(dict))
    SampleDistribution(Dict{K,Float64}(k=>Float64(v/total) for (k,v) ∈ dict))
end

export SampleDistribution

# this will do counts for you
SampleDistribution(v::AbstractVector) = SampleDistribution(proportionmap(v))


supportkeys(d::SampleDistribution) = keys(d.map)
support(d::SampleDistribution) = collect(supportkeys(d))

getsample(d::SampleDistribution, i::Integer) = d.inverse_map[i]
