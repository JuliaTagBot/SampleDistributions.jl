
@testset "distributionsapi" begin
    v = Char['a', 'a', 'b', 'c']
    d = SampleDistribution(v)
    @test ncategories(d) == 3
    for i ∈ 1:3
        @test rand(d) ∈ v
    end
    @test pdf(d, 'a') ≈ 0.5
    @test pdf(d, 'b') ≈ 0.25
    @test pdf(d, 'c') ≈ 0.25
    @test logpdf(d, 'a') ≈ log(0.5)
    @test insupport(d, 'a')
    @test !insupport(d, 'f')
    @test_throws MethodError insupport(d, 1)
    @test cdf(d, 'a') ≈ 1.0
    @test cdf(d, 'b') ≈ 0.5
    @test minimum(d) == 'a'
    @test maximum(d) == 'c'
    @test mode(d) == 'a'
    @test modes(d) == Char['a']
    @test_throws MethodError mgf(d, 1.0)
    @test_throws MethodError cf(d, 1.0)
    d2 = SampleDistribution([1, 1, 2, 3])
    @test cdf(d2, 1) ≈ 1.0
    @test cdf(d2, 2) ≈ 0.5
    @test mean(d2) ≈ 1.75
    @test 8.22 ≤ mgf(d2, 1.0) ≤ 8.23
    @test -0.082 ≤ real(cf(d2, 1.0)) ≤ -0.081
end
