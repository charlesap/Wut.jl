module Wut

struct ScalarEncoder 

	w::Number            # width of the contiguous 1 bits, must be odd
	minval::Number       # minimum value of input signal
	maxval::Number       # maximum value of input signal (strictly less when periodic = true)
	periodic::Bool       # input values wrap around and maxval input is mapped onto minval
	n::Number            # output bit width (must be greater than w)
	radius::Number       # input value difference > radius do not overlap bits
	resolution::Number   # input value difference >= resolution do not give identical bits
	name::AbstractString # optional descriptive string
	verbosity::Number 
	clipInput::Bool      # Non-periodic inputs are clipped to minval / maxval
	forced::Bool         # skip some safety checks

	function ScalarEncoder(;w=0,minval=0,maxval=0,periodic=false,
				n=0,radius=0,resolution=0,name="",
				verbosity=0,clipInput=false,forced=false)
		new(w,minval,maxval,periodic,n,radius,resolution,name,verbosity,clipInput,forced)
	end

end
export ScalarEncoder

struct BitPat
	e::Unsigned
	b::BitArray{1}
	BitPat(e,b) = new(e,BitArray(e))
end
export BitPat

function encode(e::ScalarEncoder, n::Number)
	BitPat(e.n,n)
end
export encode



function Base.show(io::IO, m::BitPat)
	print(io,"[")
	for (i,v) in enumerate(m.b)
		v ? print(io," 1") : print(io," 0")
	end
	print(io," ]")
end

function getWidth(e::ScalarEncoder)
	e.n
end
export getWidth

function getDescription(e::ScalarEncoder)
	e.name
end
export getDescription

function getBucketIndices(e::ScalarEncoder)

end
export getBucketIndices

function encodeIntoArray(e::ScalarEncoder)

end
export encodeIntoArray

function decode(e::ScalarEncoder)

end
export decode

function getBucketValues(e::ScalarEncoder)

end
export getBucketValues

function getBucketInfo(e::ScalarEncoder)

end
export getBucketInfo

function topDownCompute(e::ScalarEncoder)

end
export topDownCompute

function closenessScores(e::ScalarEncoder)

end
export closenessScores







end # module
