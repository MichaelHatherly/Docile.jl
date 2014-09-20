abstract Docstring

const FORMATS = Dict{Symbol, Any}()

# Default to markdown format.
formatted(file) = get(FORMATS, symbol(splitext(file)[end][2:end]), :md)(readall(file))

for (ext, T) in [("md",  :MarkdownDocstring)]
    @eval begin
        $(Expr(:toplevel, Expr(:export, symbol("@$(ext)_str"), symbol("@$(ext)_mstr"))))
        
        type $(T) <: Docstring
            content::String
        end
        
        push!($FORMATS, $(Expr(:quote, symbol(ext))), $T)
        
        @docref () -> $(symbol("REF_$(uppercase(ext))_STR"))
        macro $(symbol("$(ext)_str"))(content, flags...)
            Expr(:call, Expr(:quote, $T), "i" in flags ? interpolate(content) : content)
        end
        
        @docref () -> $(symbol("REF_$(uppercase(ext))_MSTR"))
        macro $(symbol("$(ext)_mstr"))(content, flags...)
            content = triplequoted(content)
            Expr(:call, Expr(:quote, $T), "i" in flags ? interpolate(content) : content)
        end
    end
end
