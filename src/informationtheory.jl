# this file contains some information theoretic functionals of probability distributions
# should ultimately spin this off into separate package
# functional benchmarked just as fast as direct methods!!!


# TODO make this work for functions with ℵ₀ support
function functional(d::Distribution{T, Discrete}, f::Function, st::Function=(x -> true)) where T
    o = 0.0
    for k ∈ support(d)
        if st(k)
            o += f(k)
        end
    end
    o
end

function functional(d::SampleDistribution, f::Function, st::Function=(x -> true))
    o = 0.0
    for i ∈ 1:ncategories(d)
        if st(getsample(d, i))
            o += f(pdfbyindex(d, i))
        end
    end
    o
end
export functional


Hfunc(p::Real) = -p*log(p)
H(d::SampleDistribution, st::Function=(x -> true)) = functional(d, Hfunc, st)
export H



