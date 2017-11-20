
# for now all these methods just call from underlying categorical
params(d::NamedCategorical) = params(d.dist)
ncategories(d::NamedCategorical) = ncategories(d.dist)


