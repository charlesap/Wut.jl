# included in module Wut


struct ScalarEncoder <: AbstractEncoder

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
    
        pad = padding > 0 ? padding : ( periodic ? 0 : convert(Int64,round((w-1)/2)) )
    
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
            nfloat = (w * (rag / rad)) + (2 * pad)
            n = Int32(ceil(nfloat))        
        end
    
        #pad = periodic ? 0 : convert(Int64,round((w-1)/2))
        nm = (name != "") ? name : @sprintf("[%s:%s]" , minval, maxval)
    
        new(w,minval,maxval,periodic,n,rad,res,nm,verbosity,clipInput,forced,pad,rag)
    end

end
export ScalarEncoder

function getWidth(e::ScalarEncoder)
    e.n
end
export getWidth

function getDescription(e::ScalarEncoder)
    e.name
end
export getDescription

function getName(e::ScalarEncoder)
    e.name
end
export getName

function getBucketIndices(e::ScalarEncoder)

end
export getBucketIndices

function encodeIntoArray(e::ScalarEncoder,n::Number,b::BitPat;learn=true, offset=0, length=0)
    #fill!(b.b,false)
    for i = 1 : e.n
       b.b[i+offset]=false 
    end
    t1 = e.periodic ? n % e.maxval : n
    t2 = t1 > e.maxval ? e.maxval : t1
    t = t2 < e.minval ? e.minval : t2
    
    c = convert(Int64,trunc((((t - e.minval) + e.resolution/2) / e.resolution ) + e.padding))
    d = convert(Int64,(e.w-1)/2)

    for i = 1+c-d : 1+c+d
      if i <= e.n && i > 0
        b.b[i+offset]=true
      end
    end
    
    b
end
export encodeIntoArray

function decode(e::ScalarEncoder, b::BitPat; parentFieldName="")
    
    parentName = (parentFieldName == "") ? e.name : @sprintf("%s.%s", parentFieldName, e.name)
    x=Dict(parentName => [])
    r=("concrete",x,[parentName])

    if any(b.b)
        
      # ------------------------------------------------------------------------
      # First, assume the input pool is not sampled 100%, and fill in the
      #  "holes" in the encoded representation (which are likely to be present
      #  if this is a coincidence that was learned by the SP).

      # Search for portions of the output that have "holes"
      mz = (e.w - 1)/2
      for i = 0 : mz - 1
         sS = new(BitArray(i+3))
         fill!(sS,false)
         sS[1]=true
         sS[i+3]=true
         subLen=i+3

#        # Does this search string appear in the output?
        if e.periodic
          for j = 0 : E.n -1
#            outputIndices = numpy.arange(j, j + subLen)
#            outputIndices %= self.n
#            if numpy.array_equal(searchStr, tmpOutput[outputIndices]):
#              tmpOutput[outputIndices] = 1
           end
        else
          for j = 1 :(E.n - subLen + 1)
#            if numpy.array_equal(searchStr, tmpOutput[j:j + subLen]):
#              tmpOutput[j:j + subLen] = 1
          end
        end
      end  
#      # ------------------------------------------------------------------------
#      # Find each run of 1's.
#      nz = tmpOutput.nonzero()[0]
#      runs = []     # will be tuples of (startIdx, runLength)
#      run = [nz[0], 1]
#      i = 1
#      while (i < len(nz)):
#        if nz[i] == run[0] + run[1]:
#          run[1] += 1
#        else:
#          runs.append(run)
#          run = [nz[i], 1]
#        i += 1
#      runs.append(run)

#      # If we have a periodic encoder, merge the first and last run if they
#      #  both go all the way to the edges
#      if self.periodic and len(runs) > 1:
#        if runs[0][0] == 0 and runs[-1][0] + runs[-1][1] == self.n:
#          runs[-1][1] += runs[0][1]
#          runs = runs[1:]


#      # ------------------------------------------------------------------------
#      # Now, for each group of 1's, determine the "left" and "right" edges, where
#      #  the "left" edge is inset by halfwidth and the "right" edge is inset by
#      #  halfwidth.
#      # For a group of width w or less, the "left" and "right" edge are both at
#      #   the center position of the group.
#      ranges = []
#      for run in runs:
#        (start, runLen) = run
#        if runLen <= self.w:
#          left = right = start + runLen / 2
#        else:
#          left = start + self.halfwidth
#          right = start + runLen - 1 - self.halfwidth

#        # Convert to input space.
#        if not self.periodic:
#          inMin = (left - self.padding) * self.resolution + self.minval
#          inMax = (right - self.padding) * self.resolution + self.minval
#        else:
#          inMin = (left - self.padding) * self.range / self.nInternal + self.minval
#          inMax = (right - self.padding) * self.range / self.nInternal + self.minval
#        # Handle wrap-around if periodic
#        if self.periodic:
#          if inMin >= self.maxval:
#            inMin -= self.range
#            inMax -= self.range

#        # Clip low end
#        if inMin < self.minval:
#          inMin = self.minval
#        if inMax < self.minval:
#          inMax = self.minval

#        # If we have a periodic encoder, and the max is past the edge, break into
#        #  2 separate ranges
#        if self.periodic and inMax >= self.maxval:
#          ranges.append([inMin, self.maxval])
#          ranges.append([self.minval, inMax - self.range])
#        else:
#          if inMax > self.maxval:
#            inMax = self.maxval
#          if inMin > self.maxval:
#            inMin = self.maxval
#          ranges.append([inMin, inMax])

#      desc = self._generateRangeDescription(ranges)
                
    end
    
    r

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
