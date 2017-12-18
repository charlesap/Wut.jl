# included in module Wut

INITIAL_BUCKETS = 1000  # must be an even positive integer

struct RandomDistributedScalarEncoder 

    w::Int64             # width of the contiguous 1 bits, must be odd
    minIndex::Int64      
    maxIndex::Int64      
    offset::Float64  
    oidx::Int64
    n::Int64             # output bit width (must be greater than w)
    resolution::Float64  # input value difference >= resolution do not give identical bits
    name::AbstractString # optional descriptive string
    verbosity::Int64
    maxoverlap::Int64
    random::MersenneTwister
    bucketmap::Dict{Int64,Vector{Int64}}
    numTries::Int64
    maxBuckets::Int64

    function RandomDistributedScalarEncoder(;resolution=0.0,w=21,n=400,name="",offset=-1.0,seed=42,verbosity=0)
        
        minIndex = maxIndex = INITIAL_BUCKETS/2
        mao=2
        bm = Dict{Int64,Vector{Int64}}()
        rng=MersenneTwister(seed)
        t=shuffle(Vector(1:n))
        bm[minIndex]=t[1:w]
        new(w,minIndex,maxIndex,offset,0,n,resolution,name,verbosity,mao,rng,bm,0,INITIAL_BUCKETS)
    end

end
export RandomDistributedScalarEncoder

function encode(e::RandomDistributedScalarEncoder, n::Number)
    encodeIntoArray(e, n, BitPat(e.n,n))
end
export encode

function getWidth(e::RandomDistributedScalarEncoder)
    e.n
end
export getWidth

function getDescription(e::RandomDistributedScalarEncoder)
    e.name
end
export getDescription

function getBucketIndices(e::RandomDistributedScalarEncoder,x::Float64)

    if e.offset==-1.0
        e.offset=convert(Float64,x)
    end

    bucketIdx = ((e.maxBuckets/2) + convert(Int64,round((x - e.offset) / e.resolution)))

    if bucketIdx < 1
      bucketIdx = 1
    elseif bucketIdx >= e.maxBuckets
      bucketIdx = e.maxBuckets
    end
    bucketIdx
end
export getBucketIndices

function encodeIntoArray(e::RandomDistributedScalarEncoder,n::Number,b::BitPat;learn=true)
    fill!(b.b,false)
    
    
    idx=getBucketIndices(e,convert(Float64,n))
    
    if ! haskey(e.bucketmap,idx)
        t=shuffle(Vector(1:e.n))
        e.bucketmap[idx]=t[1:e.w]
    end
        
    
    for i in e.bucketmap[idx]
    
        b.b[i]=true
    
    end
    
    b
end
export encodeIntoArray

function decode(e::RandomDistributedScalarEncoder)

end
export decode

function getBucketValues(e::RandomDistributedScalarEncoder)

end
export getBucketValues

function getBucketInfo(e::RandomDistributedScalarEncoder)

end
export getBucketInfo

function topDownCompute(e::RandomDistributedScalarEncoder)

end
export topDownCompute

function closenessScores(e::RandomDistributedScalarEncoder)

end
export closenessScores







# end # module
