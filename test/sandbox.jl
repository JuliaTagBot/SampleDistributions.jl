using Distributions
using SampleDistributions
using BenchmarkTools

d = SampleDistribution(['a', 'a', 'b', 'c'])
d2 = SampleDistribution([1, 1, 2, 3])

v = rand(Char['a', 'b', 'c', 'd'], 1000)
D = SampleDistribution(v)
