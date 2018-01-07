# included in module Wut


struct CategoryEncoder  <: AbstractEncoder
    cL::Dict{String,Int64}
    sE::ScalarEncoder


    function CategoryEncoder(;w=0, categoryList=(), forced=false)
        
        tcL=Dict(categoryList[i] => i for i = 1:length(categoryList))
        #println(tcL)
    
        e=ScalarEncoder(w = w, minval=0, maxval=length(categoryList),
                      radius=1, periodic=false, forced=forced)
        new(tcL,e)
        
        
end

end
export CategoryEncoder


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
