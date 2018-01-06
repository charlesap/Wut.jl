# included in module Wut


struct CategoryEncoder 
    cL::AbstractArray
    sE::ScalarEncoder


    function CategoryEncoder(;w=0, categoryList=(), forced=false)
        cL=categoryList
        
        e=ScalarEncoder(w = w, minval=0, maxval=length(cL),
                      radius=1, periodic=false, forced=forced)
        new(cL,e)
        
        
end

end
export CategoryEncoder


function encode(e::CategoryEncoder, n::AbstractString)
    encodeIntoArray(e, n, BitPat(e.sE.n,n))
end
export encode


function getWidth(e::CategoryEncoder)
    e.sE.n
end
export getWidth

function getDescription(e::CategoryEncoder)
    e.sE.name
end
export getDescription

function getBucketIndices(e::CategoryEncoder)

end
export getBucketIndices

function encodeIntoArray(e::CategoryEncoder,n::AbstractString,b::BitPat;learn=true)
    fill!(b.b,false)
    
    b
end
export encodeIntoArray

function decode(e::CategoryEncoder)

end
export decode

function getBucketValues(e::CategoryEncoder)

end
export getBucketValues

function getBucketInfo(e::CategoryEncoder)

end
export getBucketInfo

function topDownCompute(e::CategoryEncoder)

end
export topDownCompute

function closenessScores(e::CategoryEncoder)

end
export closenessScores







# end # module
