
inversedict(dict::Dict{T,U}) where {T,U} = Dict{U,T}(v=>k for (k,v) ∈ dict)
