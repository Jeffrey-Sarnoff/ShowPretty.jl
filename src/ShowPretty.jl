module ShowPretty

export stringpretty, showpretty, 
       prettyGroupLength, prettyGroupLength!,
       prettyGroupSeparator, prettyGroupSeparator!,
       prettyIntGroupLength, prettyIntGroupLength!,
       prettyFloatGroupLength, prettyFloatGroupLength!,
       prettyIntGroupSeparator, prettyIntGroupSeparator!,
       prettyFloatGroupSeparator, prettyFloatGroupSeparator!,
       
const groupSeparator  = '_'
const groupLength     = 4

const intgroup   = [groupLength]    ; intGroup=()->intgroup[1]
const floatgroup = [groupLength]    ; floatGroup=()->floatgroup[1]
const intsep     = [groupSeparator] ; intSep=()->intsep[1]
const floatsep   = [groupSeparator] ; floatSep=()->floatsep[1]

#  make numeric strings easier to read

stringpretty{T<:Signed}(val::T, 
  groupsize::Int=groupLength(), separator::Char=intSep()) =
    prettyInteger(val, groupsize, separator)

stringpretty{T<:AbstractFloat}(
  val::T, groupsize::Int=groupLength(), 
  iseparator::Char=intSep(), fseparator::Char=floatSep()) =
    prettyFloat(val, groupsize, iseparator, fseparator)

function stringpretty{T<:Real}(val::T, groupsize::Int=groupLength(), 
  iseparator::Char=intSep(), fseparator::Char=floatSep())
    if !prettyfiable(v)
       throw(ErrorException("type $T is not supported"))
    end   
       
    prettyFloat(string(val), groupsize, iseparator, fseparator)
end

# show easy-to-read numbers

function showpretty(io::IO, 
  val::Signed, groupsize::Int=groupLength(), separator::Char=intSep())
    s = prettyInteger(val, groupsize, separator)
    print(io, s)
end

function showpretty(io::IO, 
  val::AbstractFloat, groupsize::Int=groupLength(), 
  iseparator::Char=intSep(), fseparator::Char=floatSep())
    s = prettyFloat(val, groupsize, iseparator, fseparator)
    print(io, s)
end

function showpretty{T<:Real}(io::IO, 
  val::T, groupsize::Int=groupLength(), 
  iseparator::Char=intSep(), fseparator::Char=floatSep())
    s = stringpretty(val, groupsize, iseparator, fseparator)
    print(io, s)
end

showpretty(val::Signed, groupsize::Int=groupLength(), separator::Char=intSep()) =
    showpretty(Base.STDOUT, val, groupsize, separator)

showpretty(val::AbstractFloat, groupsize::Int=groupLength(), 
  iseparator::Char=intSep(), fseparator::Char=floatSep()) =
    showpretty(Base.STDOUT, val, groupsize, iseparator, fseparator)
    
showpretty{T<:Real}(val::T, groupsize::Int=groupLength(), 
  iseparator::Char=intSep(), fseparator::Char=floatSep()) =
    showpretty(Base.STDOUT, val, groupsize, iseparator, fseparator)


# accept integers and floats

prettyInteger(v::Signed, groupsize::Int, separator::Char) = 
    integerString(string(v), groupsize, separator)

prettyFloat(v::AbstractFloat, 
  groupsize::Int, iseparator::Char, fseparator::Char) = 
    prettyFloat(string(v), groupsize, iseparator, fseparator)

prettyFloat(v::AbstractFloat, groupsize::Int, separator::Char) = 
    prettyFloat(string(v), groupsize, separator, separator)

# handle integer and float strings

prettyInteger(s::String, groupsize::Int, separator::Char) = 
    integerString(s, groupsize, separator)

function prettyFloat(s::String, groupsize::Int, iseparator::Char, fseparator::Char)
    sinteger, sfrac =
        if contains(s,".")
           split(s,".")
        else
           s, ""
        end
        
    istr = integerString(sinteger, groupsize, iseparator)
    if sfrac == ""
       istr
    else
       fstr = fractionalString(sfrac, groupsize, fseparator)
       string(istr, ".", fstr)
    end
end

prettyFloat(s::String, groupsize::Int, separator::Char) = 
    prettyFloat(s, groupsize, separator, separator)

# do the work

function nonnegIntegerString(s::String, groupsize::Int, separator::Char)
    n = length(s)
    n==0 && return "0"

    sinteger, sexponent =
        if contains(s,"e")
           split(s,"e")
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

prettyIntGroupSeparator() = intSep()
function prettyIntGroupSeparator!(ch::Char)
    intsep[1] = ch
    nothing
end
prettyIntGroupSeparator(ch::Char) = prettyIntGroupSeparator!(ch)

prettyFloatGroupSeparator() = floatSep()
function prettyFloatGroupSeparator!(ch::Char)
    floatsep[1] = ch
    nothing
end
prettyFloatGroupSeparator(ch::Char) = prettyFloatGroupSeparator!(ch)

# test: is this a type that can be handled above
function prettyfiable{T<:Real}(val::T)
    try
        convert(BigFloat,v); true
    catch
        false
    end        
end

end # module
