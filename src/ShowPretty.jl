module ShowPretty

export stringpretty, showpretty, 
       prettyGroupLength, prettyGroupLength!,
       prettyGroupSeparator, prettyGroupSeparator!,
       prettyIntGroupLength, prettyIntGroupLength!,
       prettyFloatGroupLength, prettyFloatGroupLength!,
       prettyIntGroupSeparator, prettyIntGroupSeparator!,
       prettyFloatGroupSeparator, prettyFloatGroupSeparator!
       
const groupSeparator  = '_'
const groupLength     = 4

const intgroup   = [groupLength]    ; intGroup=()->intgroup[1]
const floatgroup = [groupLength]    ; floatGroup=()->floatgroup[1]
const intsep     = [groupSeparator] ; intSep=()->intsep[1]
const floatsep   = [groupSeparator] ; floatSep=()->floatsep[1]

#  make numeric strings easier to read

stringpretty(val::Signed, groupsize::Int, separator::Char=intSep()) =
    prettyInteger(val, groupsize, separator)
stringpretty(val::Signed, separator::Char, groupsize::Int=intGroup()) =
    stringpretty(val, groupsize, separator)
function stringpretty(val::Signed)
    groupsize, separator = intGroup(), intSep()
    stringpretty(val, groupsize, separator)
end

stringpretty{T<:Signed}(val::Rational{T}, groupsize::Int, separator::Char=intSep()) =
    string(prettyInteger(val.num, groupsize, separator),"//",prettyInteger(val.den, groupsize, separator))
stringpretty{T<:Signed}(val::Rational{T}, separator::Char, groupsize::Int=intGroup()) =
    stringpretty(val, groupsize, separator)
function stringpretty{T<:Signed}(val::Rational{T})
    groupsize, separator = intGroup(), intSep()
    stringpretty(val, groupsize, separator)
end

stringpretty(val::AbstractFloat,
        igroupsize::Int, fgroupsize::Int, iseparator::Char, fseparator::Char) =
    prettyFloat(val, igroupsize, fgroupsize, iseparator, fseparator)
stringpretty(val::AbstractFloat,
        igroupsize::Int, fgroupsize::Int, separator::Char=floatSep()) =
    stringpretty(val, igroupsize, fgroupsize, separator, separator)
stringpretty(val::AbstractFloat,
        groupsize::Int, iseparator::Char, fseparator::Char) =
    stringpretty(val, groupsize, groupsize, iseparator, fseparator)
stringpretty(val::AbstractFloat,
        groupsize::Int, separator::Char=floatSep()) =
    stringpretty(val, groupsize, groupsize, separator, separator)
stringpretty(val::AbstractFloat,
        iseparator::Char, fseparator::Char, igroupsize::Int, fgroupsize::Int) =
    stringpretty(val, igroupsize, fgroupsize, iseparator, fseparator)
stringpretty(val::AbstractFloat,
        iseparator::Char, fseparator::Char, groupsize::Int) =
    stringpretty(val, groupsize, groupsize, iseparator, fseparator)
stringpretty(val::AbstractFloat,
        separator::Char, igroupsize::Int, fgroupsize::Int) =
    stringpretty(val, igroupsize, fgroupsize, separator, separator)
stringpretty(val::AbstractFloat,
        separator::Char, groupsize::Int=floatGroup()) =
    stringpretty(val, groupsize, groupsize, separator, separator)
function stringpretty(val::AbstractFloat)
    groupsize, separator = floatGroup(), floatSep()
    stringpretty(val, groupsize, groupsize, separator, separator)
end


function stringpretty(val::Real, 
          igroupsize::Int, fgroupsize::Int, iseparator::Char, fseparator::Char)
    if !prettyfiable(v)
       throw(ErrorException("type $T is not supported"))
    end   
    prettyFloat(string(val), igroupsize, fgroupsize, iseparator, fseparator)
end
stringpretty(val::Real, igroupsize::Int, fgroupsize::Int, separator::Char=floatSep()) =
    stringpretty(val, igroupsize, fgroupsize, separator, separator)
stringpretty(val::Real, groupsize::Int, iseparator::Char, fseparator::Char) =
    stringpretty(val, groupsize, groupsize, iseparator, fseparator)
stringpretty(val::Real, groupsize::Int, separator::Char=floatSep()) =
    stringpretty(val, groupsize, groupsize, separator, separator)
stringpretty(val::Real, iseparator::Char, fseparator::Char, igroupsize::Int, fgroupsize::Int) =
    stringpretty(val, igroupsize, fgroupsize, iseparator, fseparator)
stringpretty(val::Real, iseparator::Char, fseparator::Char, groupsize::Int) =
    stringpretty(val, groupsize, groupsize, iseparator, fseparator)
stringpretty(val::Real, separator::Char, igroupsize::Int, fgroupsize::Int) =
    stringpretty(val, igroupsize, fgroupsize, separator, separator)
stringpretty(val::Real, separator::Char, groupsize::Int=floatGroup()) =
    stringpretty(val, groupsize, groupsize, separator, separator)
function stringpretty(val::Real)
    groupsize, separator = floatGroup(), floatSep()
    stringpretty(val, groupsize, groupsize, separator, separator)
end


# show easy-to-read numbers

showpretty(io::IO, val::Signed, groupsize::Int, separator::Char=intSep()) =
    show(io, stringpretty(val, groupsize, separator))
showpretty(io::IO, val::Signed, separator::Char, groupsize::Int=intGroup()) =
    show(io, stringpretty(val, groupsize, separator))
function showpretty(io::IO, val::Signed)
    groupsize, separator = intGroup(), intSep()
    show(io, stringpretty(val, groupsize, separator))
end

showpretty{T<:Signed}(io::IO, val::Rational{T}, groupsize::Int, separator::Char=intSep()) =
    string(prettyInteger(val.num, groupsize, separator),"//",prettyInteger(val.den, groupsize, separator))
showpretty{T<:Signed}(io::IO, val::Rational{T}, separator::Char, groupsize::Int=intGroup()) =
    show(io, stringpretty(val, groupsize, separator))
function showpretty{T<:Signed}(io::IO, val::Rational{T})
    groupsize, separator = intGroup(), intSep()
    show(io, stringpretty(val, groupsize, separator))
end

showpretty(io::IO, val::AbstractFloat,
        igroupsize::Int, fgroupsize::Int, iseparator::Char, fseparator::Char) =
    show(io, stringpretty(val, igroupsize, fgroupsize, iseparator, fseparator)
showpretty(io::IO, val::AbstractFloat,
        igroupsize::Int, fgroupsize::Int, separator::Char=floatSep()) =
    show(io, stringpretty(val, igroupsize, fgroupsize, separator, separator))
showpretty(io::IO, val::AbstractFloat,
        groupsize::Int, iseparator::Char, fseparator::Char) =
    show(io, stringpretty(val, groupsize, groupsize, iseparator, fseparator))
showpretty(io::IO, val::AbstractFloat,
        groupsize::Int, separator::Char=floatSep()) =
    show(io, stringpretty(val, groupsize, groupsize, separator, separator))
showpretty(io::IO, val::AbstractFloat,
        iseparator::Char, fseparator::Char, igroupsize::Int, fgroupsize::Int) =
    show(io, stringpretty(val, igroupsize, fgroupsize, iseparator, fseparator))
showpretty(io::IO, val::AbstractFloat,
        iseparator::Char, fseparator::Char, groupsize::Int) =
    show(io, stringpretty(val, groupsize, groupsize, iseparator, fseparator))
showpretty(io::IO, val::AbstractFloat,
        separator::Char, igroupsize::Int, fgroupsize::Int) =
    show(io, stringpretty(val, igroupsize, fgroupsize, separator, separator))
showpretty(io::IO, val::AbstractFloat,
        separator::Char, groupsize::Int=floatGroup()) =
    show(io, stringpretty(val, groupsize, groupsize, separator, separator))
function showpretty(io::IO, val::AbstractFloat)
    groupsize, separator = floatGroup(), floatSep()
    show(io, stringpretty(val, groupsize, groupsize, separator, separator))
end


function showpretty(io::IO, val::Real, 
          igroupsize::Int, fgroupsize::Int, iseparator::Char, fseparator::Char)
    if !prettyfiable(v)
       throw(ErrorException("type $T is not supported"))
    end   
    showpretty(io, stringpretty(val, igroupsize, fgroupsize, iseparator, fseparator))
end
showpretty(io::IO, val::Real, igroupsize::Int, fgroupsize::Int, separator::Char=floatSep()) =
    show(io, stringpretty(val, igroupsize, fgroupsize, separator, separator))
showpretty(io::IO, val::Real, groupsize::Int, iseparator::Char, fseparator::Char) =
    show(io, stringpretty(val, groupsize, groupsize, iseparator, fseparator))
showpretty(io::IO, val::Real, groupsize::Int, separator::Char=floatSep()) =
    show(io, stringpretty(val, groupsize, groupsize, separator, separator))
showpretty(io::IO, val::Real, iseparator::Char, fseparator::Char, igroupsize::Int, fgroupsize::Int) =
    show(io, stringpretty(val, igroupsize, fgroupsize, iseparator, fseparator))
showpretty(io::IO, val::Real, iseparator::Char, fseparator::Char, groupsize::Int) =
    show(io, stringpretty(val, groupsize, groupsize, iseparator, fseparator))
showpretty(io::IO, val::Real, separator::Char, igroupsize::Int, fgroupsize::Int) =
    show(io, stringpretty(val, igroupsize, fgroupsize, separator, separator))
showpretty(io::IO, val::Real, separator::Char, groupsize::Int=floatGroup()) =
    show(io, stringpretty(val, groupsize, groupsize, separator, separator))
function showpretty(io::IO, val::Real)
    groupsize, separator = floatGroup(), floatSep()
    show(io, stringpretty(val, groupsize, groupsize, separator, separator))
end

# show on STDOUT


showpretty(val::Signed, groupsize::Int, separator::Char=intSep()) =
    show(Base.STDOUT, stringpretty(val, groupsize, separator))
showpretty(val::Signed, separator::Char, groupsize::Int=intGroup()) =
    show(Base.STDOUT, stringpretty(val, groupsize, separator))
function showpretty(val::Signed)
    groupsize, separator = intGroup(), intSep()
    show(Base.STDOUT, stringpretty(val, groupsize, separator))
end

showpretty{T<:Signed}(val::Rational{T}, groupsize::Int, separator::Char=intSep()) =
    string(prettyInteger(val.num, groupsize, separator),"//",prettyInteger(val.den, groupsize, separator))
showpretty{T<:Signed}(val::Rational{T}, separator::Char, groupsize::Int=intGroup()) =
    show(Base.STDOUT, stringpretty(val, groupsize, separator))
function showpretty{T<:Signed}(val::Rational{T})
    groupsize, separator = intGroup(), intSep()
    show(Base.STDOUT, stringpretty(val, groupsize, separator))
end

showpretty(val::AbstractFloat,
        igroupsize::Int, fgroupsize::Int, iseparator::Char, fseparator::Char) =
    show(Base.STDOUT, stringpretty(val, igroupsize, fgroupsize, iseparator, fseparator)
showpretty(val::AbstractFloat,
        igroupsize::Int, fgroupsize::Int, separator::Char=floatSep()) =
    show(Base.STDOUT, stringpretty(val, igroupsize, fgroupsize, separator, separator))
showpretty(val::AbstractFloat,
        groupsize::Int, iseparator::Char, fseparator::Char) =
    show(Base.STDOUT, stringpretty(val, groupsize, groupsize, iseparator, fseparator))
showpretty(val::AbstractFloat,
        groupsize::Int, separator::Char=floatSep()) =
    show(Base.STDOUT, stringpretty(val, groupsize, groupsize, separator, separator))
showpretty(val::AbstractFloat,
        iseparator::Char, fseparator::Char, igroupsize::Int, fgroupsize::Int) =
    show(Base.STDOUT, stringpretty(val, igroupsize, fgroupsize, iseparator, fseparator))
showpretty(val::AbstractFloat,
        iseparator::Char, fseparator::Char, groupsize::Int) =
    show(Base.STDOUT, stringpretty(val, groupsize, groupsize, iseparator, fseparator))
showpretty(val::AbstractFloat,
        separator::Char, igroupsize::Int, fgroupsize::Int) =
    show(Base.STDOUT, stringpretty(val, igroupsize, fgroupsize, separator, separator))
showpretty(val::AbstractFloat,
        separator::Char, groupsize::Int=floatGroup()) =
    show(Base.STDOUT, stringpretty(val, groupsize, groupsize, separator, separator))
function showpretty(val::AbstractFloat)
    groupsize, separator = floatGroup(), floatSep()
    show(Base.STDOUT, stringpretty(val, groupsize, groupsize, separator, separator))
end


function showpretty(val::Real, 
          igroupsize::Int, fgroupsize::Int, iseparator::Char, fseparator::Char)
    if !prettyfiable(v)
       throw(ErrorException("type $T is not supported"))
    end   
    showpretty(io, stringpretty(val, igroupsize, fgroupsize, iseparator, fseparator))
end
showpretty(val::Real, igroupsize::Int, fgroupsize::Int, separator::Char=floatSep()) =
    show(Base.STDOUT, stringpretty(val, igroupsize, fgroupsize, separator, separator))
showpretty(val::Real, groupsize::Int, iseparator::Char, fseparator::Char) =
    show(Base.STDOUT, stringpretty(val, groupsize, groupsize, iseparator, fseparator))
showpretty(val::Real, groupsize::Int, separator::Char=floatSep()) =
    show(Base.STDOUT, stringpretty(val, groupsize, groupsize, separator, separator))
showpretty(val::Real, iseparator::Char, fseparator::Char, igroupsize::Int, fgroupsize::Int) =
    show(Base.STDOUT, stringpretty(val, igroupsize, fgroupsize, iseparator, fseparator))
showpretty(val::Real, iseparator::Char, fseparator::Char, groupsize::Int) =
    show(Base.STDOUT, stringpretty(val, groupsize, groupsize, iseparator, fseparator))
showpretty(val::Real, separator::Char, igroupsize::Int, fgroupsize::Int) =
    show(Base.STDOUT, stringpretty(val, igroupsize, fgroupsize, separator, separator))
showpretty(val::Real, separator::Char, groupsize::Int=floatGroup()) =
    show(Base.STDOUT, stringpretty(val, groupsize, groupsize, separator, separator))
function showpretty(val::Real)
    groupsize, separator = floatGroup(), floatSep()
    show(Base.STDOUT, stringpretty(val, groupsize, groupsize, separator, separator))
end


# accept integers and floats

prettyInteger{T<:Signed}(v::T, groupsize::Int, separator::Char) = 
    integerString(string(v), groupsize, separator)

prettyFloat{T<:AbstractFloat}(v::T, 
  igroupsize::Int, fgroupsize::Int, iseparator::Char, fseparator::Char) = 
    prettyFloat(string(v), igroupsize, fgroupsize, iseparator, fseparator)

prettyFloat{T<:AbstractFloat}(v::T, 
  igroupsize::Int, fgroupsize::Int, separator::Char) = 
    prettyFloat(string(v), igroupsize, fgroupsize, separator, separator)

prettyFloat{T<:AbstractFloat}(v::T, 
  groupsize::Int, iseparator::Char, fseparator::Char) = 
    prettyFloat(string(v), groupsize, iseparator, fseparator)

prettyFloat{T<:AbstractFloat}(v::T,  groupsize::Int, separator::Char) = 
    prettyFloat(string(v), groupsize, separator, separator)

# handle integer and float strings

splitstr(str::String, at::String) = map(String, split(str, at))

prettyInteger(s::String, groupsize::Int, separator::Char) = 
    integerString(s, groupsize, separator)

function prettyFloat(s::String, igroupsize::Int, fgroupsize::Int, iseparator::Char, fseparator::Char)
    sinteger, sfrac =
        if contains(s,".")
           splitstr(s,".")
        else
           s, ""
        end
        
    istr = integerString(sinteger, igroupsize, iseparator)
    if sfrac == ""
       istr
    else
       fstr = fractionalString(sfrac, fgroupsize, fseparator)
       string(istr, ".", fstr)
    end
end

prettyFloat(s::String, groupsize::Int, separator::Char) = 
    prettyFloat(s, groupsize, groupsize, separator, separator)

prettyFloat(s::String, groupsize::Int, iseparator::Char, fseparator::Char) = 
    prettyFloat(s, groupsize, groupsize, iseparator, fseparator)

prettyFloat(s::String, igroupsize::Int, fgroupsize::Int, separator::Char) = 
    prettyFloat(s, igroupsize, fgroupsize, separator, separator)

# do the work

function nonnegIntegerString(s::String, groupsize::Int, separator::Char)
    n = length(s)
    n==0 && return "0"

    sinteger, sexponent =
        if contains(s,"e")
           strsplit(s,"e")
        else
           s, ""
        end
    
    n = length(sinteger)

    fullgroups, finalgroup = divrem(n, groupsize)

    sv = convert(Vector{Char},sinteger)
    p = repeat(" ", n+(fullgroups-1)+(finalgroup!=0))
    pretty = convert(Vector{Char},p)
   
    sourceidx = n
    targetidx = length(pretty)
    for k in fullgroups:-1:1
        pretty[(targetidx-groupsize+1):targetidx] = sv[(sourceidx-groupsize+1):sourceidx]
        sourceidx -= groupsize
        targetidx -= groupsize
        if k > 1
            pretty[targetidx] = separator
            targetidx -= 1
        end
    end
   
    if finalgroup > 0
        if fullgroups > 0 
            pretty[targetidx] = separator
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

function integerString(s::String, groupsize::Int, separator::Char)
    if s[1] != "-"
       nonnegIntegerString(s, groupsize, separator)
    else
       s1 = string(s[2:end])
       pretty = nonnegIntegerString(s1, groupsize, separator)
       string("-", pretty)
    end    
end    

function fractionalString(s::String, groupsize::Int, separator::Char)
    sfrac, sexponent =
        if contains(s,"e")
           split(s,"e")
        else
           s, ""
        end
    
    pretty = reverse(nonnegIntegerString(reverse(sfrac), groupsize, separator))
    
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


prettyGroupSeparator() = (intSep() == floatSep()) ? intSep() : (intSep(), floatSep())
function prettyGroupSeparator!(ch::Char)
    prettyFloatGroupSeparator!(ch)
    prettyIntGroupSeparator!(ch)
    nothing
end
prettyGroupSeparator(ch::Int) = prettyGroupSeparator!(ch)
prettyGroupSeparator(ch::String) = prettyGroupSeparator!(ch[1])

prettyIntGroupSeparator() = intSep()
function prettyIntGroupSeparator!(ch::Char)
    intsep[1] = ch
    nothing
end
prettyIntGroupSeparator(ch::Char) = prettyIntGroupSeparator!(ch)
prettyIntGroupSeparator(ch::String) = prettyIntGroupSeparator!(ch[1])

prettyFloatGroupSeparator() = floatSep()
function prettyFloatGroupSeparator!(ch::Char)
    floatsep[1] = ch
    nothing
end
prettyFloatGroupSeparator(ch::Char) = prettyFloatGroupSeparator!(ch)
prettyFloatGroupSeparator(ch::String) = prettyFloatGroupSeparator!(ch[1])

# test: is this a type that can be handled above
function prettyfiable{T<:Real}(val::T)
    try
        convert(BigFloat,v); true
    catch
        false
    end        
end

end # module
