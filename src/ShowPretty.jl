module ShowPretty

export stringpretty, showpretty, 
       prettyGroupLength, prettyGroupLength!,
       prettyGroupSpacer, prettyGroupSpacer!,
       prettyIntGroupLength, prettyIntGroupLength!,
       prettyFloatGroupLength, prettyFloatGroupLength!,
       prettyIntGroupSpacer, prettyIntGroupSpacer!,
       prettyFloatGroupSpacer, prettyFloatGroupSpacer!
       
const groupSpacer  = '_'
const groupLength  =  4

const intgroup    = [groupLength] ; intGroup    =()->intgroup[1]
const intspacer   = [groupSpacer] ; intSpacer   =()->intspacer[1]
const floatgroup  = [groupLength] ; floatGroup  =()->floatgroup[1]
const floatspacer = [groupSpacer] ; floatSpacer =()->floatspacer[1]

#  make numeric strings easier to read

stringpretty(val::Signed, group::Int, spacer::Char=intSpacer()) =
    prettyInteger(val, group, spacer)
stringpretty(val::Signed, spacer::Char, group::Int=intGroup()) =
    stringpretty(val, group, spacer)
function stringpretty(val::Signed)
    group, spacer = intGroup(), intSpacer()
    stringpretty(val, group, spacer)
end

stringpretty{T<:Signed}(val::Rational{T}, group::Int, spacer::Char=intSpacer()) =
    string(prettyInteger(val.num, group, spacer),"//",prettyInteger(val.den, group, spacer))
stringpretty{T<:Signed}(val::Rational{T}, spacer::Char, group::Int=intGroup()) =
    stringpretty(val, group, spacer)
function stringpretty{T<:Signed}(val::Rational{T})
    group, spacer = intGroup(), intSpacer()
    stringpretty(val, group, spacer)
end

stringpretty(val::AbstractFloat,
        intGroup::Int, fracGroup::Int, intSpacer::Char, fracSpacer::Char) =
    prettyFloat(val, intGroup, fracGroup, intSpacer, fracSpacer)
stringpretty(val::AbstractFloat,
        intGroup::Int, fracGroup::Int, spacer::Char=floatSpacer()) =
    stringpretty(val, intGroup, fracGroup, spacer, spacer)
stringpretty(val::AbstractFloat,
        group::Int, intSpacer::Char, fracSpacer::Char) =
    stringpretty(val, group, group, intSpacer, fracSpacer)
stringpretty(val::AbstractFloat,
        group::Int, spacer::Char=floatSpacer()) =
    stringpretty(val, group, group, spacer, spacer)
stringpretty(val::AbstractFloat,
        intSpacer::Char, fracSpacer::Char, intGroup::Int, fracGroup::Int) =
    stringpretty(val, intGroup, fracGroup, intSpacer, fracSpacer)
stringpretty(val::AbstractFloat,
        intSpacer::Char, fracSpacer::Char, group::Int) =
    stringpretty(val, group, group, intSpacer, fracSpacer)
stringpretty(val::AbstractFloat,
        spacer::Char, intGroup::Int, fracGroup::Int) =
    stringpretty(val, intGroup, fracGroup, spacer, spacer)
stringpretty(val::AbstractFloat,
        spacer::Char, group::Int=floatGroup()) =
    stringpretty(val, group, group, spacer, spacer)
function stringpretty(val::AbstractFloat)
    group, spacer = floatGroup(), floatSpacer()
    stringpretty(val, group, group, spacer, spacer)
end


function stringpretty(val::Real, 
          intGroup::Int, fracGroup::Int, intSpacer::Char, fracSpacer::Char)
    if !prettyfiable(v)
       throw(ErrorException("type $T is not supported"))
    end   
    prettyFloat(string(val), intGroup, fracGroup, intSpacer, fracSpacer)
end
stringpretty(val::Real, intGroup::Int, fracGroup::Int, spacer::Char=floatSpacer()) =
    stringpretty(val, intGroup, fracGroup, spacer, spacer)
stringpretty(val::Real, group::Int, intSpacer::Char, fracSpacer::Char) =
    stringpretty(val, group, group, intSpacer, fracSpacer)
stringpretty(val::Real, group::Int, spacer::Char=floatSpacer()) =
    stringpretty(val, group, group, spacer, spacer)
stringpretty(val::Real, intSpacer::Char, fracSpacer::Char, intGroup::Int, fracGroup::Int) =
    stringpretty(val, intGroup, fracGroup, intSpacer, fracSpacer)
stringpretty(val::Real, intSpacer::Char, fracSpacer::Char, group::Int) =
    stringpretty(val, group, group, intSpacer, fracSpacer)
stringpretty(val::Real, spacer::Char, intGroup::Int, fracGroup::Int) =
    stringpretty(val, intGroup, fracGroup, spacer, spacer)
stringpretty(val::Real, spacer::Char, group::Int=floatGroup()) =
    stringpretty(val, group, group, spacer, spacer)
function stringpretty(val::Real)
    group, spacer = floatGroup(), floatSpacer()
    stringpretty(val, group, group, spacer, spacer)
end


# show easy-to-read numbers

showpretty(io::IO, val::Signed, group::Int, spacer::Char=intSpacer()) =
    show(io, stringpretty(val, group, spacer))
showpretty(io::IO, val::Signed, spacer::Char, group::Int=intGroup()) =
    show(io, stringpretty(val, group, spacer))
function showpretty(io::IO, val::Signed)
    group, spacer = intGroup(), intSpacer()
    show(io, stringpretty(val, group, spacer))
end

showpretty{T<:Signed}(io::IO, val::Rational{T}, group::Int, spacer::Char=intSpacer()) =
    string(prettyInteger(val.num, group, spacer),"//",prettyInteger(val.den, group, spacer))
showpretty{T<:Signed}(io::IO, val::Rational{T}, spacer::Char, group::Int=intGroup()) =
    show(io, stringpretty(val, group, spacer))
function showpretty{T<:Signed}(io::IO, val::Rational{T})
    group, spacer = intGroup(), intSpacer()
    show(io, stringpretty(val, group, spacer))
end

showpretty(io::IO, val::AbstractFloat,
        intGroup::Int, fracGroup::Int, intSpacer::Char, fracSpacer::Char) =
    show(io, stringpretty(val, intGroup, fracGroup, intSpacer, fracSpacer))
showpretty(io::IO, val::AbstractFloat,
        intGroup::Int, fracGroup::Int, spacer::Char=floatSpacer()) =
    show(io, stringpretty(val, intGroup, fracGroup, spacer, spacer))
showpretty(io::IO, val::AbstractFloat,
        group::Int, intSpacer::Char, fracSpacer::Char) =
    show(io, stringpretty(val, group, group, intSpacer, fracSpacer))
showpretty(io::IO, val::AbstractFloat,
        group::Int, spacer::Char=floatSpacer()) =
    show(io, stringpretty(val, group, group, spacer, spacer))
showpretty(io::IO, val::AbstractFloat,
        intSpacer::Char, fracSpacer::Char, intGroup::Int, fracGroup::Int) =
    show(io, stringpretty(val, intGroup, fracGroup, intSpacer, fracSpacer))
showpretty(io::IO, val::AbstractFloat,
        intSpacer::Char, fracSpacer::Char, group::Int) =
    show(io, stringpretty(val, group, group, intSpacer, fracSpacer))
showpretty(io::IO, val::AbstractFloat,
        spacer::Char, intGroup::Int, fracGroup::Int) =
    show(io, stringpretty(val, intGroup, fracGroup, spacer, spacer))
showpretty(io::IO, val::AbstractFloat,
        spacer::Char, group::Int=floatGroup()) =
    show(io, stringpretty(val, group, group, spacer, spacer))
function showpretty(io::IO, val::AbstractFloat)
    group, spacer = floatGroup(), floatSpacer()
    show(io, stringpretty(val, group, group, spacer, spacer))
end


function showpretty(io::IO, val::Real, 
          intGroup::Int, fracGroup::Int, intSpacer::Char, fracSpacer::Char)
    if !prettyfiable(v)
       throw(ErrorException("type $T is not supported"))
    end   
    showpretty(io, stringpretty(val, intGroup, fracGroup, intSpacer, fracSpacer))
end
showpretty(io::IO, val::Real, intGroup::Int, fracGroup::Int, spacer::Char=floatSpacer()) =
    show(io, stringpretty(val, intGroup, fracGroup, spacer, spacer))
showpretty(io::IO, val::Real, group::Int, intSpacer::Char, fracSpacer::Char) =
    show(io, stringpretty(val, group, group, intSpacer, fracSpacer))
showpretty(io::IO, val::Real, group::Int, spacer::Char=floatSpacer()) =
    show(io, stringpretty(val, group, group, spacer, spacer))
showpretty(io::IO, val::Real, intSpacer::Char, fracSpacer::Char, intGroup::Int, fracGroup::Int) =
    show(io, stringpretty(val, intGroup, fracGroup, intSpacer, fracSpacer))
showpretty(io::IO, val::Real, intSpacer::Char, fracSpacer::Char, group::Int) =
    show(io, stringpretty(val, group, group, intSpacer, fracSpacer))
showpretty(io::IO, val::Real, spacer::Char, intGroup::Int, fracGroup::Int) =
    show(io, stringpretty(val, intGroup, fracGroup, spacer, spacer))
showpretty(io::IO, val::Real, spacer::Char, group::Int=floatGroup()) =
    show(io, stringpretty(val, group, group, spacer, spacer))
function showpretty(io::IO, val::Real)
    group, spacer = floatGroup(), floatSpacer()
    show(io, stringpretty(val, group, group, spacer, spacer))
end

# show on STDOUT


showpretty(val::Signed, group::Int, spacer::Char=intSpacer()) =
    showpretty(Base.STDOUT, val, group, spacer)
showpretty(val::Signed, spacer::Char, group::Int=intGroup()) =
    showpretty(Base.STDOUT, val, group, spacer)
function showpretty(val::Signed)
    group, spacer = intGroup(), intSpacer()
    showpretty(Base.STDOUT, val, group, spacer)
end

showpretty{T<:Signed}(val::Rational{T}, group::Int, spacer::Char=intSpacer()) =
    string(prettyInteger(val.num, group, spacer),"//",prettyInteger(val.den, group, spacer))
showpretty{T<:Signed}(val::Rational{T}, spacer::Char, group::Int=intGroup()) =
    showpretty(Base.STDOUT, val, group, spacer)
function showpretty{T<:Signed}(val::Rational{T})
    group, spacer = intGroup(), intSpacer()
    showpretty(Base.STDOUT, val, group, spacer)
end

showpretty(val::AbstractFloat,
        intGroup::Int, fracGroup::Int, intSpacer::Char, fracSpacer::Char) =
    showpretty(Base.STDOUT, val, intGroup, fracGroup, intSpacer, fracSpacer)
showpretty(val::AbstractFloat, rest...) = showpretty(Base.STDOUT, rest...)

function showpretty(val::Real, 
          intGroup::Int, fracGroup::Int, intSpacer::Char, fracSpacer::Char)
    if !prettyfiable(v)
       throw(ErrorException("type $T is not supported"))
    end   
    showpretty(Base.STDOUT, val, intGroup, fracGroup, intSpacer, fracSpacer)
end
showpretty(val::Real, rest...) = showpretty(Base.STDOUT, rest...)


# accept integers and floats

prettyInteger{T<:Signed}(v::T, group::Int, spacer::Char) = 
    integerString(string(v), group, spacer)

prettyFloat{T<:AbstractFloat}(v::T, 
  intGroup::Int, fracGroup::Int, intSpacer::Char, fracSpacer::Char) = 
    prettyFloat(string(v), intGroup, fracGroup, intSpacer, fracSpacer)

prettyFloat{T<:AbstractFloat}(v::T, 
  intGroup::Int, fracGroup::Int, spacer::Char) = 
    prettyFloat(string(v), intGroup, fracGroup, spacer, spacer)

prettyFloat{T<:AbstractFloat}(v::T, 
  group::Int, intSpacer::Char, fracSpacer::Char) = 
    prettyFloat(string(v), group, intSpacer, fracSpacer)

prettyFloat{T<:AbstractFloat}(v::T,  group::Int, spacer::Char) = 
    prettyFloat(string(v), group, spacer, spacer)

# handle integer and float strings

splitstr(str::String, at::String) = map(String, split(str, at))

prettyInteger(s::String, group::Int, spacer::Char) = 
    integerString(s, group, spacer)

function prettyFloat(s::String, intGroup::Int, fracGroup::Int, intSpacer::Char, fracSpacer::Char)
    sinteger, sfrac =
        if contains(s,".")
           splitstr(s,".")
        else
           s, ""
        end
        
    istr = integerString(sinteger, intGroup, intSpacer)
    if sfrac == ""
       istr
    else
       fstr = fractionalString(sfrac, fracGroup, fracSpacer)
       string(istr, ".", fstr)
    end
end

prettyFloat(s::String, group::Int, spacer::Char) = 
    prettyFloat(s, group, group, spacer, spacer)

prettyFloat(s::String, group::Int, intSpacer::Char, fracSpacer::Char) = 
    prettyFloat(s, group, group, intSpacer, fracSpacer)

prettyFloat(s::String, intGroup::Int, fracGroup::Int, spacer::Char) = 
    prettyFloat(s, intGroup, fracGroup, spacer, spacer)

# do the work

function nonnegIntegerString(s::String, group::Int, spacer::Char)
    n = length(s)
    n==0 && return "0"

    sinteger, sexponent =
        if contains(s,"e")
           strsplit(s,"e")
        else
           s, ""
        end
    
    n = length(sinteger)

    fullgroups, finalgroup = divrem(n, group)

    sv = convert(Vector{Char},sinteger)
    p = repeat(" ", n+(fullgroups-1)+(finalgroup!=0))
    pretty = convert(Vector{Char},p)
   
    sourceidx = n
    targetidx = length(pretty)
    for k in fullgroups:-1:1
        pretty[(targetidx-group+1):targetidx] = sv[(sourceidx-group+1):sourceidx]
        sourceidx -= group
        targetidx -= group
        if k > 1
            pretty[targetidx] = spacer
            targetidx -= 1
        end
    end
   
    if finalgroup > 0
        if fullgroups > 0 
            pretty[targetidx] = spacer
            targetidx -= 1
        end     
        pretty[(targetidx-finalgroup+1):targetidx] = sv[(sourceidx-finalgroup+1):sourceidx]
    end

    prettystring = convert(String, pretty)

    if length(sexponent) != 0
       string(prettystring,"e",sexponent)
    else
       prettystring
    end
end

function integerString(s::String, group::Int, spacer::Char)
    if s[1] != "-"
       nonnegIntegerString(s, group, spacer)
    else
       s1 = string(s[2:end])
       pretty = nonnegIntegerString(s1, group, spacer)
       string("-", pretty)
    end    
end    

function fractionalString(s::String, group::Int, spacer::Char)
    sfrac, sexponent =
        if contains(s,"e")
           split(s,"e")
        else
           s, ""
        end
    
    pretty = reverse(nonnegIntegerString(reverse(sfrac), group, spacer))
    
    if length(sexponent) != 0
       string(pretty,"e",sexponent)
    else
       pretty
    end
end

# get and set shared parameters

prettyGroupLength() = (intGroup() == floatGroup()) ? intGroup() : (intGroup(), floatGroup())
function prettyGroupLength!(n::Int)
    n = max(0,n)
    prettyIntGroupLength!(n)
    prettyFloatGroupLength!(n)
    nothing
end
prettyGroupLength(n::Int) = prettyGroupLength!(n)

prettyIntGroupLength() = intGroup()
function prettyIntGroupLength!(n::Int)
    n = max(0,n)
    intgroup[1]   = n
    nothing
end
prettyIntGroupLength(n::Int) = prettyIntGroupLength!(n)

prettyFloatGroupLength() = floatGroup()
function prettyFloatGroupLength!(n::Int)
    n = max(0,n)
    floatgroup[1]   = n
    nothing
end
prettyFloatGroupLength(n::Int) = prettyFloatGroupLength!(n)


prettyGroupSpacer() = (intSpacer() == floatSpacer()) ? intSpacer() : (intSpacer(), floatSpacer())
function prettyGroupSpacer!(ch::Char)
    prettyFloatGroupSpacer!(ch)
    prettyIntGroupSpacer!(ch)
    nothing
end
prettyGroupSpacer(ch::Int) = prettyGroupSpacer!(ch)
prettyGroupSpacer(ch::String) = prettyGroupSpacer!(ch[1])

prettyIntGroupSpacer() = intSpacer()
function prettyIntGroupSpacer!(ch::Char)
    intspacer[1] = ch
    nothing
end
prettyIntGroupSpacer(ch::Char) = prettyIntGroupSpacer!(ch)
prettyIntGroupSpacer(ch::String) = prettyIntGroupSpacer!(ch[1])

prettyFloatGroupSpacer() = floatSpacer()
function prettyFloatGroupSpacer!(ch::Char)
    floatspacer[1] = ch
    nothing
end
prettyFloatGroupSpacer(ch::Char) = prettyFloatGroupSpacer!(ch)
prettyFloatGroupSpacer(ch::String) = prettyFloatGroupSpacer!(ch[1])

# test: is this a type that can be handled above
function prettyfiable{T<:Real}(val::T)
    try
        convert(BigFloat,v); true
    catch
        false
    end        
end

end # module
