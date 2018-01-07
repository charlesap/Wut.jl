module Wut

include("BitPat.jl")

abstract type AbstractEncoder
end

function encode(a::AbstractEncoder, v)
    encodeIntoArray(a, v, BitPat(getWidth(a)))
end
export encode


include("ScalarEncoder.jl")

#include("AdaptiveScalarEncoder.jl")
include("CategoryEncoder.jl")
#include("CoordinateEncoder.jl")
include("DateEncoder.jl")
#include("DeltaEncoder.jl")
#include("GeospatialCoordinateEncoder.jl")
#include("LogEncoder.jl")
#include("MultiEncoder.jl")
#include("PassThroughEncoder.jl")
include("RandomDistributedScalarEncoder.jl")
#include("SDRCategoryEncoder.jl")
#include("ScalarSpaceEncoder.jl")
#include("SparsePassThroughEncoder.jl")

end # module
