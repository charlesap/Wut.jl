# included in module Wut

struct BitPat
    b::BitArray{1}
    BitPat(b) = new(BitArray(b))
end
export BitPat

function Base.show(io::IO, m::BitPat)
    print(io,"[")
    for (i,v) in enumerate(m.b)
        v ? print(io," 1") : print(io," 0")
    end
    print(io," ]")
end


#end # module