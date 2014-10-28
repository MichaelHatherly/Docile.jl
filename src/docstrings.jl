for ext in [:md, :txt]
    @eval begin
        $(Expr(:toplevel, Expr(:export, symbol("@$(ext)_str"), symbol("@$(ext)_mstr"))))

        @docref () -> $(symbol(uppercase("REF_$(ext)_STR")))
        macro $(symbol("$(ext)_str"))(content, flags...)
            _build_expression(content, flags, $(Expr(:quote, ext)))
        end

        @docref () -> $(symbol(uppercase("REF_$(ext)_MSTR")))
        macro $(symbol("$(ext)_mstr"))(content, flags...)
            _build_expression(triplequoted(content), flags, $(Expr(:quote, ext)))
        end
    end
end

function _build_expression(content, flags, ext)
    Expr(:call, Expr(:curly, :Docs, Expr(:quote, ext)),
         "i" in flags ? interpolate(content) : content)
end
