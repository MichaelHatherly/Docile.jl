# methods

for fn in [:g1, :g2, :g3]
    @eval begin
        "One line, loop generated doc for $($(string(fn)))."
        $(fn)(x) = x
    end
end

for fn in [:h1, :h2, :h3]
    @eval begin
        """
        Multiline, loop generated doc for $($fn).
        """
        $(fn)(x) = x
    end
end

for fn in [:j1, :j2, :j3]
    @eval begin
        "One line, loop generated doc for $($fn)."
        function $(fn)(x)
            x
        end
    end
end

for fn in [:k1, :k2, :k3]
    @eval begin
        """
        Multiline, loop generated doc for $($fn).
        """
        function $(fn)(x)
            x
        end
    end
end

# macros

for fn in [:n1, :n2, :n3]
    @eval begin
        "One line, loop generated doc for @$($(string(fn))) macro."
        macro $(fn)(x)
            x
        end
    end
end

for fn in [:o1, :o2, :o3]
    @eval begin
        """
        Multiline, loop generated doc for @$($(string(fn))) macro.
        """
        macro $(fn)(x)
            x
        end
    end
end

# types

for T in [:S1, :S2, :S3]
    @eval begin
        "One line, loop generated doc for $($(string(T))) type."
        type $(T)
        end
    end
end

for T in [:R1, :R2, :R3]
    @eval begin
        """
        Multineline, loop generated doc for $($(string(T))) type.
        """
        type $(T)
        end
    end
end

for T in [:U1, :U2, :U3]
    @eval begin
        "One line, loop generated doc for $($(string(T))) abstract type."
        abstract $(T)
    end
end

for T in [:V1, :V2, :V3]
    @eval begin
        """
        One line, loop generated doc for $($(string(T))) abstract type.
        """
        abstract $(T)
    end
end
