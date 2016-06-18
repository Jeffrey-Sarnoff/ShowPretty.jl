## ShowPretty.jl
###### easily read numbers with many digits

To Install: `julia> Pkg.clone("https://github.com/Jeffrey-Sarnoff/ShowPretty.jl")`

##### Use
```julia
> using ShowPretty    # exports stringpretty, showpretty, 
                      # intSizer(<nDigitsPerGroup>), floatSizer(<nDigitsPerGroup>)
                      # intSpacer(<UTF8char>), floatSpacer(<UTF8char>),

> intSpacer(), intSizer, floatSpacer(), floatSizer()           # ('_', 4, '_', 4) default values
> intSpacer(','), intSizer(3), floatSpacer('_'), floatSizer(5) # (',', 3, '_', 5) specified values

> stringpretty(1234567) # "1,234,567"
> showpretty(-1234567)
-1,234,567

> stringpretty(12345.987654321)             # "12,345.98765_4321"
> stringpretty(12345.987654,',',3)          # "12,345.987.654,3
> stringpretty(0.9876,4,'_')                # "0.9876"

> intSpacer(','); intSizer(3); showpretty(12345678.87654321)
1.234,567,887,654,321e7
> showpretty(inv(12345678.87654321),'_',4)
8.1000_0008_91e-8

```
