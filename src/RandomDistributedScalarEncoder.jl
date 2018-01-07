# included in module Wut

INITIAL_BUCKETS = 1000  # must be an even positive integer

mutable struct RandomDistributedScalarEncoder  <: AbstractEncoder

    w::Int32             # width of the contiguous 1 bits, must be odd
    minIndex::Int32      
    maxIndex::Int32      
    offset::Float64  
    oidx::Int32
    n::Int32             # output bit width (must be greater than w)
    resolution::Float64  # input value difference >= resolution do not give identical bits
    name::AbstractString # optional descriptive string
    verbosity::Int32
    maxoverlap::Int32
    random::MersenneTwister
    bucketmap::Dict{Int32,Vector{Int32}}
    numTries::Int32
    maxBuckets::Int32

    function RandomDistributedScalarEncoder(;resolution=0.0,w=21,n=400,name="",offset=NaN,seed=42,verbosity=0)
        
        minIndex = maxIndex = INITIAL_BUCKETS/2
        mao=2
        bm = Dict{Int32,Vector{Int32}}()
        rng=MersenneTwister(seed)
        t=shuffle(Vector(1:n))
        bm[minIndex]=t[1:w]
        new(w,minIndex,maxIndex,offset,0,n,resolution,name,verbosity,mao,rng,bm,0,INITIAL_BUCKETS)
    end

end
export RandomDistributedScalarEncoder

function getWidth(e::RandomDistributedScalarEncoder)
    e.n
end
export getWidth

function getDescription(e::RandomDistributedScalarEncoder)
    e.name
end
export getDescription

function repOK(e::RandomDistributedScalarEncoder,v::Vector)
   true 
end

function newRepresentation(e::RandomDistributedScalarEncoder, nidx::Int32, idx::Int32)
    
    
    t=shuffle(Vector(1:e.n))
    x=shuffle(e.bucketmap[idx])
    n=vcat(t[1],x[2:e.w])
    while ! repOK(e,n) 
        t=shuffle(Vector(1:e.n))
        x=shuffle(e.bucketmap[idx])
        n=vcat(t[1],x[2:e.w])
    end
    n

end

function createBucket(e::RandomDistributedScalarEncoder, idx::Int32)
    
    z=convert(Int32,0)
    if idx < e.minIndex
        z=e.minIndex
        if idx == e.minIndex - 1
            e.minIndex-=1
        else
            createBucket(e,convert(Int32,idx+1))
        end
    else
        z=e.maxIndex
        if idx == e.maxIndex + 1
            e.maxIndex+=1
        else
            createBucket(e,convert(Int32,idx-1))
        end
    end
    
    e.bucketmap[idx]=newRepresentation(e,idx,z)
    
end

function mapBucketIndexToNonZeroBits(e::RandomDistributedScalarEncoder, index::Int32)
    
    idx = index < 1 ? 1 : ( index > e.maxBuckets ? e.maxBuckets : index )

    if ! haskey(e.bucketmap,idx)
        createBucket(e,idx)
    end
    
    e.bucketmap[idx]
end
    
function getBucketIndices(e::RandomDistributedScalarEncoder,x::Float64)

    if isnan(e.offset)
        e.offset=convert(Float64,x)
    end

    bucketIdx = convert(Int32,((e.maxBuckets/2) + convert(Int32,round((x - e.offset) / e.resolution))))

    if bucketIdx < 1
      bucketIdx = 1
    elseif bucketIdx >= e.maxBuckets
      bucketIdx = e.maxBuckets
    end
    bucketIdx
end
export getBucketIndices

function encodeIntoArray(e::RandomDistributedScalarEncoder,n::Number,b::BitPat;learn=true, offset=0, length=0)
    fill!(b.b,false)
    
    
    idx=getBucketIndices(e,convert(Float64,n))
    
    nzb=mapBucketIndexToNonZeroBits(e,idx)
    
    for i in nzb
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
