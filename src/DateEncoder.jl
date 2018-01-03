# included in module Wut


struct DateEncoder 

    season::Number
    dayOfWeek::Number
    weekend::Number
    holiday::Number
    timeOfDay::Number
    customDays::Number
    name::AbstractString
    forced::Bool

    w::Number            # width of the contiguous 1 bits, must be odd
    n::Number     

    seasonEncoder::Nullable{ScalarEncoder}
    dayOfWeekEncoder::Nullable{ScalarEncoder}
    weekendEncoder::Nullable{ScalarEncoder}
    holidayEncoder::Nullable{ScalarEncoder}
    timeOfDayEncoder::Nullable{ScalarEncoder}
    customDaysEncoder::Nullable{ScalarEncoder}
           # output bit width (must be greater than w)

    function DateEncoder(;season=0, dayOfWeek=0, weekend=0, holiday=0, timeOfDay=0, customDays=0, name = "", forced=true)
        w=3
        n=21
        z=Nullable{ScalarEncoder}()
        sE=Nullable{ScalarEncoder}()
        sE = season== 0 ? z : ScalarEncoder(w = season, minval=0, maxval=366,
                                         radius=91.5, periodic=true,
                                         name="season", forced=forced)
    
        new(season, dayOfWeek, weekend, holiday, timeOfDay, customDays, name, forced, w, n, sE, z, z, z, z, z)
        
        
        
    end

end
export DateEncoder


function encode(e::DateEncoder, d::AbstractString)
    encodeIntoArray(e, d, BitPat(e.n,d))
end
export encode

function getWidth(e::DateEncoder)
    e.n
end
export getWidth

function getDescription(e::DateEncoder)
    e.name
end
export getDescription

function getBucketIndices(e::DateEncoder)

end
export getBucketIndices

function encodeIntoArray(e::DateEncoder,d::AbstractString,b::BitPat;learn=true)
    fill!(b.b,false)
    
    b
end
export encodeIntoArray

function decode(e::DateEncoder)

end
export decode

function getBucketValues(e::DateEncoder)

end
export getBucketValues

function getBucketInfo(e::DateEncoder)

end
export getBucketInfo

function topDownCompute(e::DateEncoder)

end
export topDownCompute

function closenessScores(e::DateEncoder)

end
export closenessScores







# end # module
