
struct NamedCategorical{T,K} <: Distribution
    dist::Categorical{T}
    name_map::Dict{K,Int}
end


function NamedCategorical(p::AbstractVector{T}, dict::Dict{K,<:Integer}) where {T<:Real,K}
    NamedCategorical{T,K}(Categorical{T}(p), dict)
end

# this is a dict with probabilities as values
function NamedCategorical(dict::Dict{K,T}) where {K,T<:AbstractFloat}
    ks = collect(keys(dict))
    p = getindex.(dict, ks)
    NamedCategorical{K,T}(Categorical{T}(p), Dict(ks[i]=>i for i ∈ 1:length(ks)))
end

# this is a dict with counts as values
function NamedCategorical(dict::Dict{K,T}) where {K,T<:Integer}
    total = sum(values(dict))
    NamedCategorical(Dict{K,Float64}(k=>Float64(v/total) for (k,v) ∈ dict))
end

# this will do counts for you
NamedCategorical(v::AbstractVector) = NamedCategorical(proportionmap(v))
