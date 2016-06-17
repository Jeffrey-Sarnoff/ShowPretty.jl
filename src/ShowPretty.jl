module ShowPretty

export showpretty

const separator = '_'

function nonnegIntegerString(s::String, groupsize::Int=5)
   n = length(s)
   fullgroups, finalgroup = divrem(n, groupsize)

   sv = convert(Vector{Char},s)
   p = repeat(" ", n+(fullgroups-1)+(finalgroup!=0)+length(numsign))
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
       pretty[targetidx] = separator
       targetidx -= 1
       pretty[(targetidx-finalgroup+1):targetidx] = sv[(sourceidx-finalgroup+1):sourceidx]
       targetidx -= 1
   end

   convert(String, pretty)
end

function integerString(s::String, groupsize::Int=5)
    numsign = s[1]=="-" ? "-" : ""
    pretty = nonnegIntegerString(s[(1+length(numsign)):end], groupsize)
    String(numsign, pretty)
end    

function fractionalString(s::String, groupsize::Int=5)
    sfrac, sexponent =
        if "e" in s
           split(s,"e")
        else
           s, ""
        end
    
    pretty = reverse(nonnegIntegerString(reverse(sfrac), groupsize))
    
    if sexponent != ""
       join(pretty,sexponent,"e")
    else
       pretty
    end
end


end # module
