module ShowPretty

export showpretty

const separator = '_'

function nonnegIntegerString(s::String, groupsize::Int=5)
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

    if sexponent != ""
       join((prettystring,sexponent),"e")
    else
       prettystring
    end
end

function integerString(s::String, groupsize::Int=5)
    if s[1] != "-"
       nonnegIntegerString(s, groupsize)
    else
       s1 = string(s[2:end])
       pretty = nonnegIntegerString(s1, groupsize)
       string("-", pretty)
    end    
end    

function fractionalString(s::String, groupsize::Int=5)
    sfrac, sexponent =
        if contains(s,"e")
           split(s,"e")
        else
           s, ""
        end
    
    pretty = reverse(nonnegIntegerString(reverse(sfrac), groupsize))
    
    if sexponent != ""
       join((pretty,sexponent),"e")
    else
       pretty
    end
end

function realpretty(s::String, groupsize::Int=5)
    sinteger, sfrac =
        if contains(s,".")
           split(s,".")
        else
           s, ""
        end
        
    if sfrac == ""
       integerString(sinteger, groupsize)
    else
       join( (integerString(sinteger, groupsize), fractionString(sfrac, groupsize)), "." )
    end
end


end # module
