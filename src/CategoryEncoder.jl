# included in module Wut


struct CategoryEncoder  <: AbstractEncoder
    cL::Dict{String,Int64}
    sE::ScalarEncoder


    function CategoryEncoder(;w=0, categoryList=(), forced=false)
        
        tcL=Dict(categoryList[i] => i for i = 1:length(categoryList))
        
    
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

function getName(e::CategoryEncoder)
    e.sE.name
end
export getName

function getBucketIndices(e::CategoryEncoder)

end
export getBucketIndices

function encodeIntoArray(e::CategoryEncoder,n::Void,b::BitPat;learn=true)
    fill!(b.b,false)
    b
end
function encodeIntoArray(e::CategoryEncoder,n::AbstractString,b::BitPat;learn=true)
    t=get(e.cL,n,0)
    encodeIntoArray(e.sE,convert(Int32,t),b)
    
    b
end
export encodeIntoArray

#function decode(e::CategoryEncoder, b::BitPat; parentFieldName="")
#
#end
#export decode

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
