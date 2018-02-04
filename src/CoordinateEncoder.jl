# included in module Wut


struct CoordinateEncoder 

    w::Number            # width of the contiguous 1 bits, must be odd
    n::Number            # output bit width (must be greater than w)


    function CoordinateEncoder(;w=0,n=0)
        res=(maxval-minval)/n
        new(w,n)
        
        
end

end
export CoordinateEncoder


function encode(e::CoordinateEncoder, n::Number)
    encodeIntoArray(e, n, BitPat(e.n,n))
end
export encode


function getWidth(e::CoordinateEncoder)
    e.n
end
export getWidth

function getDescription(e::CoordinateEncoder)
   e.name
end
export getDescription

function getBucketIndices(e::CoordinateEncoder)

end
export getBucketIndices

function encodeIntoArray(e::CoordinateEncoder,n::Number,b::BitPat;learn=true)
    
    b
end
export encodeIntoArray

function decode(e::CoordinateEncoder)

end
export decode

function getBucketValues(e::CoordinateEncoder)

end
export getBucketValues

function getBucketInfo(e::CoordinateEncoder)

end
export getBucketInfo

function topDownCompute(e::CoordinateEncoder)

end
export topDownCompute

function closenessScores(e::CoordinateEncoder)

end
export closenessScores







# end # module
