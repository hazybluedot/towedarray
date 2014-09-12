using TowedArray

function printsys{T}(io::IO, u, x::Array{T,1}, s::SignedMeasurement, z::Angle)
    print(io, "$(join(reshape(u, length(u)),',')),$(join(x,',')),$(s.dz.dz),$(z.dz)\n")
end

u0 = [1.0,0.015]

u(x) = [fill(NaN, length(u0)) u0]

for (num,line) in enumerate(readlines(STDIN))
    ic = map(s -> float(strip(s)), split(line,','))

    open( "tatraj_$(num).csv", "w" ) do io
        tasys = make_tasys(ic[1:4], ic[5:9])
        simcb(tasys, u, (x,u,s,z) -> printsys(io,u,x,s,z), 120)
    end
end
