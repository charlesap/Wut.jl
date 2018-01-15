module Wut

include("BitPat.jl")

abstract type AbstractEncoder
end

# implemented by all concrete encoders:
#   getWidth(a::ConcreteEncoder) 
#   getDescription(a::ConcreteEncoder)
#   encodeIntoArray(a::ConcreteEncoder, inputData, output)

#  function setLearning(a::AbstractEncoder, learningEnabled):
#  function setFieldStats(a::AbstractEncoder, fieldName, fieldStatistics):
#  function getScalarNames(a::AbstractEncoder, parentFieldName=''):
#  function getDecoderOutputFieldTypes(a::AbstractEncoder):
#  function setStateLock(a::AbstractEncoder,lock):
#  function _getInputValue(a::AbstractEncoder, obj, fieldName):
#  function getEncoderList(a::AbstractEncoder):
#  function getScalars(a::AbstractEncoder, inputData):
#  function getEncodedValues(a::AbstractEncoder, inputData):
#  function getBucketIndices(a::AbstractEncoder, inputData):
#  function scalarsToStr(a::AbstractEncoder, scalarValues, scalarNames=None):
#  function getFieldDescription(a::AbstractEncoder, fieldName):
#  function encodedBitDescription(a::AbstractEncoder, bitOffset, formatted=False):
#  function pprintHeader(a::AbstractEncoder, prefix=""):
#  function pprint(a::AbstractEncoder, output, prefix=""):
#  function decode(a::AbstractEncoder, encoded, parentFieldName=''):
#  function decodedToStr(a::AbstractEncoder, decodeResults):
#  function getBucketValues(a::AbstractEncoder):
#  function getBucketInfo(a::AbstractEncoder, buckets):
#  function topDownCompute(a::AbstractEncoder, encoded):
#  function closenessScores(a::AbstractEncoder, expValues, actValues, fractional=True):

function encode(a::AbstractEncoder, v)
    encodeIntoArray(a, v, BitPat(getWidth(a)))
end
export encode

function getDisplayWidth(a::AbstractEncoder)
     getWidth(a) + length(getDescription(a)) - 1
end
export getDisplayWidth

function decode(e::AbstractEncoder, b::BitPat; parentFieldName="")
    
    parentName = (parentFieldName == "") ? getName(e) : @sprintf("%s.%s", parentFieldName, getName(e))
    x=Dict(parentName => [])
    (x,[parentName])
end
export decode





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
