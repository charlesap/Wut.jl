module Wut

struct ScalarEncoder 

	w::Number
	minval::Number
	maxval::Number
	periodic::Bool
	n::Number
	radius::Number
	resolution::Number
	name::AbstractString
	verbosity::Number
	clipInput::Bool
	forced::Bool

	function ScalarEncoder(;w=0,minval=0,maxval=0,periodic=false,
				n=0,radius=0,resolution=0,name="",
				verbosity=0,clipInput=false,forced=false)
		new(w,minval,maxval,periodic,n,radius,resolution,name,verbosity,clipInput,forced)
	end

end
export ScalarEncoder

struct BitPat
	e::Number
	b::Int64
	
	function BitPat(e,b)
		new(e,b)
	end
end
export BitPat

function encode(e::ScalarEncoder, n::Number)
	BitPat(e.n,n)
	
end
export encode

function Base.show(io::IO, m::BitPat)
       print(io,bin(0,m.e))
end


end # module
