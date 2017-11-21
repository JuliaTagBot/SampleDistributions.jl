import Distributions: params, ncategories, probs
import Distributions: rand, pdf, logpdf, cdf
import Distributions: insupport, mode, modes
import Distributions: mgf, cf
import Base: mean, minimum, maximum
import StatsBase: entropy

# for now all these methods just call from underlying categorical
params(d::SampleDistribution) = params(d.dist)
ncategories(d::SampleDistribution) = ncategories(d.dist)
probs(d::SampleDistribution) = probs(d.dist)

rand(d::SampleDistribution) = getsample(d, rand(d.dist))
pdf(d::SampleDistribution{T,K}, x::K) where {T,K} = pdf(d.dist, d.map[x])
logpdf(d::SampleDistribution{T,K}, x::K) where {T,K} = log(pdf(d, x))

insupport(d::SampleDistribution{T,K}, x::K) where {T,K} = (x ∈ supportkeys(d))

# requires ≥
function cdf(d::SampleDistribution{T,K}, x::K) where {T,K}
    sum(pdf(d, k) for k ∈ supportkeys(d) if k ≥ x)
end

# it would be up to users to define quantile

# requires * and +  TODO: can avoid dict lookup
mean(d::SampleDistribution) = sum(k*pdf(d, k) for k ∈ supportkeys(d))
# requires ≤
minimum(d::SampleDistribution) = minimum(supportkeys(d))
# requlres ≥
maximum(d::SampleDistribution) = maximum(supportkeys(d))
mode(d::SampleDistribution) = getsample(d, mode(d.dist))
modes(d::SampleDistribution) = getsample.(d, modes(d.dist))

# skewness and kurtosis are up to user

entropy(d::SampleDistribution) = entropy(d.dist)

# TODO can avoid dict look-ups in these
# requires exp(t*k)
mgf(d::SampleDistribution, t::Real) = sum(pdf(d, k)*exp(t*k) for k ∈ supportkeys(d))
# requires exp(im*t*k)
cf(d::SampleDistribution, t::Real) = sum(pdf(d, k)*exp(im*t*k) for k ∈ supportkeys(d))
