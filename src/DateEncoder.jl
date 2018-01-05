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

    w::Number            # cumulative width of the discontiguous 1 bits
    n::Number            # width of composite encoding

    sE::Nullable{ScalarEncoder} # SeasonEncoder
    sEo::Int64

    dE::Nullable{ScalarEncoder} # dayOfWeekEncoder
    dEo::Int64

    wE::Nullable{ScalarEncoder} # weekendEncoder
    wEo::Int64

    hE::Nullable{ScalarEncoder} # holidayEncoder
    hEo::Int64

    tE::Nullable{ScalarEncoder} # timeOfDayEncoder
    tEo::Int64

    cE::Nullable{ScalarEncoder} # customDaysEncoder
    cEo::Int64
          

    function DateEncoder(;season=0, dayOfWeek=0, weekend=0, holiday=0, timeOfDay=0, customDays=0, name = "", forced=true)
        w=0
        n=0
        z=Nullable{ScalarEncoder}()
    
        sE=Nullable{ScalarEncoder}()
        sE = season== 0 ? z : ScalarEncoder(w = season, minval=0, maxval=366,
                                         radius=91.5, periodic=true,
                                         name="season", forced=forced)
        n=isnull(sE) ? 0 : getWidth(sE)
        sEo=0
    
        dE=Nullable{ScalarEncoder}()
        dE = dayOfWeek== 0 ? z : ScalarEncoder(w = dayOfWeek, minval=0, maxval=7,
                                         radius=1, periodic=true,
                                         name="day of week", forced=forced)
        dEo=n
        n=isnull(dE) ? n : n + getWidth(dE)
    
        wE=Nullable{ScalarEncoder}()
        wE = weekend== 0 ? z : ScalarEncoder(w = weekend, minval=0, maxval=2,
                                         radius=1, periodic=true,
                                         name="weekend", forced=forced)
        wEo=n
        n=isnull(wE) ? n : n + getWidth(wE)
    
        cE=Nullable{ScalarEncoder}()
        cE = customDays== 0 ? z : ScalarEncoder(w = customDays, minval=0, maxval=7,
                                         radius=1, periodic=true,
                                         name="custom days", forced=forced)
        cEo=n
        n=isnull(cE) ? n : n + getWidth(cE)
    
        hE=Nullable{ScalarEncoder}()
        hE = holiday== 0 ? z : ScalarEncoder(w = holiday, minval=0, maxval=7,
                                         radius=1, periodic=true,
                                         name="holiday", forced=forced)
        hEo=n
        n=isnull(hE) ? n : n + getWidth(hE)
    
        tE=Nullable{ScalarEncoder}()
        tE = timeOfDay== 0 ? z : ScalarEncoder(w = timeOfDay, minval=0, maxval=7,
                                         radius=1, periodic=true,
                                         name="time of day", forced=forced)
        tEo=n
        n=isnull(tE) ? n : n + getWidth(tE)
    
            new(season, dayOfWeek, weekend, holiday, timeOfDay, customDays, name, forced, 
                 w, n, sE, sEo, dE, dEo, wE, wEo, hE, hEo, tE, tEo, cE, cEo)
        
        
        
    end

end
export DateEncoder


function encode(e::DateEncoder, d::DateTime)
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

function encodeIntoArray(e::DateEncoder,d::DateTime,b::BitPat;learn=true, offset=0, length=0)
    fill!(b.b,false)
    
    timeOfDay=0    
    
    if ! isnull(e.sE) # seasson
        dy=Dates.dayofyear(d)
        b.b[e.sEo+1]=true
        encodeIntoArray(get(e.sE),dy-1,b,learn = true, offset = e.sEo)
    end
    if ! isnull(e.dE) # day of week
        dw=Dates.dayofweek(d)
        b.b[e.dEo+1]=true
        encodeIntoArray(get(e.dE),dw-1,b,learn = true, offset = e.dEo)
    end
    if ! isnull(e.wE) # weekend
        weekend = 0
        b.b[e.wEo+1]=true
    end
    if ! isnull(e.hE) # holiday
        isholiday = 0
        b.b[e.hEo+1]=true
    end
    if ! isnull(e.tE) # time of day
        b.b[e.tEo+1]=true
    end
    if ! isnull(e.cE) # custom days
        customDay = 0
        b.b[e.cEo+1]=true
    end
    
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
