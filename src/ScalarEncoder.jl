# included in module Wut


struct ScalarEncoder 

    w::Int64             # width of the contiguous 1 bits, must be odd
    minval::Float64      # minimum value of input signal
    maxval::Float64      # maximum value of input signal (strictly less when periodic = true)
    periodic::Bool       # input values wrap around and maxval input is mapped onto minval
    n::Int64             # output bit width (must be greater than w)
    radius::Float64      # input value difference > radius do not overlap bits
    resolution::Float64  # input value difference >= resolution do not give identical bits
    name::AbstractString # optional descriptive string
    verbosity::Int64
    clipInput::Bool      # Non-periodic inputs are clipped to minval / maxval
    forced::Bool         # skip some safety checks
    padding::Int64
    range::Float64


    function ScalarEncoder(;w=0,minval=0.0,maxval=0.0,periodic=false,
            n=0,radius=0.0,resolution=0.0,name="",
            verbosity=0,clipInput=false,forced=false,padding=0,range=0.0)

        res = rad = rag = 0.0
    
        if n != 0 && radius == 0.0 && resolution == 0.0 
           res = periodic ? (maxval-minval)/n : (maxval-minval)/(n-w)
           rad = w*res
           rag = periodic ? maxval-minval : maxval-minval+res

        elseif n == 0 && radius != 0.0 && resolution == 0.0
           rad = radius
           res = radius / w
          
        elseif n == 0 && radius == 0.0 && resolution != 0.0
           res = resolution
           rad = res * w

        else
           
        end
    
        if n == 0
            rag = periodic ? maxval-minval : maxval-minval+res
            nfloat = w * (rag / rad) + 2 * padding
            n = Int32(ceil(nfloat))        
        end
    
        pad = periodic ? 0 : convert(Int64,round((w-1)/2))
    
        new(w,minval,maxval,periodic,n,rad,res,name,verbosity,clipInput,forced,pad,rag)
    end

end
export ScalarEncoder

function encode(e::ScalarEncoder, n::Number)
    encodeIntoArray(e, n, BitPat(e.n,n))
end
export encode


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

function encodeIntoArray(e::ScalarEncoder,n::Number,b::BitPat;learn=true)
    fill!(b.b,false)
    t1 = e.periodic ? n % e.maxval : n
    t2 = t1 > e.maxval ? e.maxval : t1
    t = t2 < e.minval ? e.minval : t2
    
    c = convert(Int64,trunc((((t - e.minval) + e.resolution/2) / e.resolution ) + e.padding))
    d = convert(Int64,(e.w-1)/2)

    for i = 1+c-d : 1+c+d
      if i <= e.n && i > 0
        b.b[i]=true
      end
    end
    
    b
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







# end # module
