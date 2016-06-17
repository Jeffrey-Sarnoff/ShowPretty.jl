module ShowPretty

export stringpretty, showpretty, prettyGroupLength, prettyGroupLength!

const underscore = '_'
const grouplength = [5]

prettyGroupLength() = grouplength[1]
function prettyGroupLength!(n::Int)
    grouplength[1] = max(0,n)
    nothing
end
prettyGroupLength(n::Int) = prettyGroupLength!(n)

aschar(x::Char) = x
aschar(x::String) = x!="" ? x[1] : throw(DomainError)

function nonnegIntegerString(s::String, 
  groupsize::Int=grouplength[1], separator::Char=underscore)
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

function integerString(s::String, 
  groupsize::Int=grouplength[1], separator::Char=underscore)
    if s[1] != "-"
       nonnegIntegerString(s, groupsize, separator)
    else
       s1 = string(s[2:end])
       pretty = nonnegIntegerString(s1, groupsize, separator)
       string("-", pretty)
    end    
end    

function fractionalString(s::String, 
  groupsize::Int=grouplength[1], separator::Char=underscore)
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


prettyInteger(s::String, groupsize::Int=grouplength[1], separator::Char=underscore) = 
    integerString(s, groupsize, separator)

function prettyFloat(s::String, 
  groupsize::Int=5, iseparator::Char=underscore, fseparator::Char=underscore)
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

prettyFloat(s::String, groupsize::Int=grouplength[1], separator::Char=underscore) = 
    prettyFloat(s, groupsize, separator, separator)

prettyInteger(v::Signed, groupsize::Int=grouplength[1], separator::Char=underscore) = 
    integerString(String(s), groupsize, separator, separator)

prettyFloat(v::AbstractFloat, groupsize::Int=grouplength[1], separator::Char=underscore) = 
    prettyFloat(String(v), groupsize, separator, separator)

prettyFloat(v::AbstractFloat, 
  groupsize::Int=grouplength[1], iseparator::Char=underscore, fseparator::Char=underscore) = 
    prettyFloat(String(v), groupsize, iseparator, fseparator)


stringpretty{T<:Signed}(val::T, groupsize::Int=grouplength[1], separator::Char=underscore) =
    prettyInteger(val, groupsize, separator)

stringpretty{T<:AbstractFloat}(
  val::T, groupsize::Int=grouplength[1], 
  iseparator::Char=underscore, fseparator::Char=underscore) =
    prettyFloat(val, groupsize, iseparator, fseparator)

function showpretty(io::IO, 
  val::Signed, groupsize::Int=grouplength[1], separator::Char=underscore)
    s = prettyInteger(val, groupsize, separator)
    print(io, s)
end

function showpretty(io::IO, 
  val::AbstractFloat, groupsize::Int=grouplength[1], 
  iseparator::Char=underscore, fseparator::Char=underscore)
    s = prettyFloat(val, groupsize, iseparator, fseparator)
    print(io, s)
end

function stringpretty{T<:Real}(val::T, groupsize::Int=grouplength[1], 
  iseparator::Char=underscore, fseparator::Char=underscore)
    if !(try begin convert(BigFloat,v); true end; catch return false; end)
       throw(ErrorException("type $T is not supported"))
    end   
       
    prettyFloat(string(val), groupsize, iseparator, fseparator)
end

function showpretty{T<:Real}(io::IO, 
  val::T, groupsize::Int=grouplength[1], 
  iseparator::Char=underscore, fseparator::Char=underscore)
    s = stringpretty(val, groupsize, iseparator, fseparator)
    print(io, s)
end

showpretty(val::Signed, groupsize::Int=grouplength[1], separator::Char=underscore) =
    showpretty(Base.STDOUT, val, groupsize, separator)

showpretty(val::AbstractFloat, groupsize::Int=grouplength[1], 
  iseparator::Char=underscore, fseparator::Char=underscore) =
    showpretty(Base.STDOUT, val, groupsize, iseparator, fseparator)
    
showpretty{T<:Real}(val::T, groupsize::Int=grouplength[1], 
  iseparator::Char=underscore, fseparator::Char=underscore) =
    showpretty(Base.STDOUT, val, groupsize, iseparator, fseparator)

end # module
