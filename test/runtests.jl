#/usr/bin/env julia

using Wut
using Base.Test

# Run tests

tic()

@time @test include("ScalarEncoderTests.jl")
@time @test include("RandomDistributedScalarEncoderTests.jl")

toc()
