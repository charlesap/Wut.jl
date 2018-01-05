# included in module Wut


struct CategoryEncoder 

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
    padding::Number


    function CategoryEncoder(;w=0,minval=0,maxval=0,periodic=false,
				n=0,radius=0,resolution=1,name="",
				verbosity=0,clipInput=false,forced=false,padding=0)
        res=(maxval-minval)/n
		new(w,minval,maxval,periodic,n,w*res,res,name,verbosity,clipInput,forced,periodic?0:(w-1)/2)
        
        
end

end
export CategoryEncoder

#struct BitPat
#	e::Unsigned
#	b::BitArray{1}
#	BitPat(e,b) = new(e,BitArray(e))
#end
#export BitPat

function encode(e::CategoryEncoder, n::Number)
	encodeIntoArray(e, n, BitPat(e.n,n))
end
export encode

#function Base.show(io::IO, m::BitPat)
#	print(io,"[")
#	for (i,v) in enumerate(m.b)
#		v ? print(io," 1") : print(io," 0")
#	end
#	print(io," ]")
#end

function getWidth(e::CategoryEncoder)
	e.n
end
export getWidth

function getDescription(e::CategoryEncoder)
	e.name
end
export getDescription

function getBucketIndices(e::CategoryEncoder)

end
export getBucketIndices

function encodeIntoArray(e::CategoryEncoder,n::Number,b::BitPat;learn=true)
	fill!(b.b,false)
	t1 = e.periodic ? n % e.maxval : n
	t2 = t1 > e.maxval ? e.maxval : t1
	t = t2 < e.minval ? e.minval : t2
    
    c = convert(Int64,round((((t - e.minval) + e.resolution/2) / e.resolution )))# + e.padding))
    
#	i=convert(Int64,round(t*e.n/e.maxval))
    d=convert(Int64,(e.w-1)/2)
    for i = c-d : c+d
	  if i <= e.n && i > 0
        b.b[i]=true
      end
    end
    
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
