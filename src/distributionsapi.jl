# TODO special methods for array types

import Distributions: params, ncategories, probs
import Distributions: rand, pdf, logpdf, cdf
import Distributions: insupport, mode, modes
import Distributions: mgf, cf
import Base: mean, var, minimum, maximum, std
import StatsBase: entropy, moment, skewness, kurtosis

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

# requires * and +
mean(d::SampleDistribution) = expectation(d, x -> x)
# requires ≤
minimum(d::SampleDistribution) = minimum(supportkeys(d))
# requlres ≥
maximum(d::SampleDistribution) = maximum(supportkeys(d))
mode(d::SampleDistribution) = getsample(d, mode(d.dist))
modes(d::SampleDistribution) = getsample.(d, modes(d.dist))

# written this way so users only need to define - and *
var(d::SampleDistribution{T,K}, μ=mean(d)) where {T,K} = expectation(d, x -> (x - μ)*(x - μ))

std(d::SampleDistribution{T,K}, μ=mean(d)) where {T,K} = sqrt(var(d, μ))

# TODO these probably really inefficient, why mismatch with StatsBase?
moment(d::SampleDistribution, k::Integer, μ=mean(d)) = expectation(d, x -> (x - μ)^k)
skewness(d::SampleDistribution, μ=mean(d)) = moment(d, 3, μ)/std(d, μ)^3
kurtosis(d::SampleDistribution, μ=mean(d)) = moment(d, 4, μ)/var(d, μ)^2

entropy(d::SampleDistribution) = entropy(d.dist)

# requires exp(t*k)
mgf(d::SampleDistribution, t::Real) = expectation(d, x -> exp(t*x))
# requires exp(im*t*k)
cf(d::SampleDistribution, t::Real) = expectation(d, x -> exp(im*t*x))
