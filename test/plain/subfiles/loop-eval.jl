for i = 1:2, T = (Integer, Float64), fn = [:lg_1, :lg_2]
    @eval begin
        "$($(string(fn))) $($(i)) $($(T))"
        $(fn)(a::Array{$(T), $(i)}) = a
    end
end

@comment file"external-docs.md"

# Adapted from arpack.jl.
for (T, TR, naupd_name, neupd_name) in

    ((Complex128, Float64, :znaupd_, :zneupd_),
     (Complex64, Float32, :cnaupd_, :cneupd_))

    @eval begin
        "lg_3"
        function lg_3(ido, bmat, n, evtype, nev, TOL::Array{$TR}, resid::Array{$T},
                      ncv, v::Array{$T}, ldv, iparam, ipntr, workd::Array{$T},
                      workl::Array{$T}, lworkl, rwork::Array{$TR}, info)

        end
        "lg_4"
        function lg_4(rvec, howmny, select, d, z, ldz, sigma, workev::Array{$T},
                      bmat, n, evtype, nev, TOL::Array{$TR}, resid::Array{$T},
                      ncv, v::Array{$T}, ldv, iparam, ipntr, workd::Array{$T},
                      workl::Array{$T}, lworkl, rwork::Array{$TR}, info)
        end
    end
end

for Tn = (:lg_T_1, :lg_T_2)
    @eval begin
        "$($(string(Tn)))"
        type $(Tn)

        end
    end
end
