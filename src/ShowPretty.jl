module ShowPretty

export stringpretty, showpretty, 
       prettyGroupLength, prettyGroupLength!,
       prettyIntSeparator, prettyIntSeparator!,
       prettyFloatSeparator, prettyFloatSeparator!,
       
const underscore = '_'
const grouplength = [5]
const intsep = [underscore]
const floatsep = [underscore]

groupLength=()->grouplength[1]
intSep=()->intsep[1]
floatSep=()->floatsep[1]

stringpretty{T<:Signed}(val::T, 
  groupsize::Int=groupLength(), separator::Char=intSep()) =
    prettyInteger(val, groupsize, separator)

stringpretty{T<:AbstractFloat}(
  val::T, groupsize::Int=groupLength(), 
  iseparator::Char=underscore, fseparator::Char=intSep()) =
    prettyFloat(val, groupsize, iseparator, fseparator)

function stringpretty{T<:Real}(val::T, groupsize::Int=groupLength(), 
  iseparator::Char=intSep(), fseparator::Char=floatSep())
    if !(try begin convert(BigFloat,v); true end; catch return false; end)
       throw(ErrorException("type $T is not supported"))
    end   
       
    prettyFloat(string(val), groupsize, iseparator, fseparator)
end


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


# handle integers and floats

prettyInteger(v::Signed, groupsize::Int, separator::Char) = 
    integerString(String(s), groupsize, separator, separator)

prettyFloat(v::AbstractFloat, groupsize::Int, separator::Char) = 
    prettyFloat(String(v), groupsize, separator, separator)

prettyFloat(v::AbstractFloat, 
  groupsize::Int, iseparator::Char, fseparator::Char) = 
    prettyFloat(String(v), groupsize, iseparator, fseparator)

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

function nonnegIntegerString(s::String, groupsize::Int, separator::Cha)
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

function integerString(s::String, groupsize::Int separator::Char=underscore)
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

prettyGroupLength() = grouplength[1]
function prettyGroupLength!(n::Int)
    grouplength[1] = max(0,n)
    nothing
end
prettyGroupLength(n::Int) = prettyGroupLength!(n)

prettyIntSeparator() = intsep[1]
function prettyIntSeparator!(ch::Char)
    intsep[1] = ch
    nothing
end
prettyIntSeparator(ch::Char) = prettyIntSeparator!(ch)

prettyFloatSeparator() = floatsep[1]
function prettyFloatSeparator!(ch::Char)
    floatsep[1] = ch
    nothing
end
prettyFloatSeparator(ch::Char) = prettyFloatSeparator!(ch)

end # module
