using Base.Test, TowedArray.Control, TowedArray.Types, TowedArray.Models, TowedArray

u0 = [1.0,0.015]

const auv_controller = (x) -> [ fill(NaN,2) u0 ]

function printsys{T}(x::Vector{T}, u::Matrix{T}, s::SignedMeasurement, z::Angle)
    println("$(join(reshape(u, length(u)),',')),$(join(x,',')),$(s.dz.dz),$(z.dz)")
end

xt0 = [0.0, 0.0, 0.5, 0.75]
xo0 = [10.0, 5.0, 0.5, 0.5, 0.0]
dt = 0.1
u0 = [1.0,0.015]

tasys = TASystem(xt0, xo0) #TowedArraySystem(xt0, xo0, dt, @task Control.steady(u0))

@show tasys

simcb(tasys, auv_controller, printsys, 5)
