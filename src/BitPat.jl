# included in module Wut

struct BitPat
	e::Unsigned
	b::BitArray{1}
	BitPat(e,b) = new(e,BitArray(e))
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