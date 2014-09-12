using TowedArray, TowedArray.Types, TowedArray.Models

const MEASUREMENT_MIN_VALUE = Angle(-pi/2)
const MEASUREMENT_MAX_VALUE = Angle(pi/2)

macro view(expr)
    return quote
        info($(string(expr)), ": ", string($expr))
    end
end

function mirror(dz::Angle)
    (dz < MEASUREMENT_MIN_VALUE) && return SignedMeasurement(-pi - dz, -1)
    (dz > MEASUREMENT_MAX_VALUE) && return SignedMeasurement( pi - dz, -1)
    
    return SignedMeasurement(dz,1)
end

type TAMeasurement <: AbstractModel
    auv::AbstractModel
end

TAMeasurement(auv::AbstractModel) = TAMeasurement(auv, 
                                                  (x) -> h(x, yawof(auv)), 
                                                  (x) -> ∇x_h(x, yawof(auv)),
                                                  (x) -> noise_var(x, yawof(auv)),
                                                  (x) -> ∇x_σ(x, signof(h(x,yawof(auv))), yawof(auv))
       
                                           )

return function h(xo::Vector,q::Vector)
    x = xo - q[1:4]
    ψ = q[5]
    h(x, ψ)
end

function h{T}(x::Vector{T}, ψ::T)
    dz = Angle(atan2(x[2], x[1]) - ψ - pi/2)
    mirror(dz)
end

function mes_h(mm::TARelative)
    (x) -> h(x, sys_ψ(mm))
end

function g{T}(x::Vector{T})
    a = TowedArray.params.a
    dg =  a[3]- norm(x[1:2])
    dg = a[1] + a[2] * dg*dg;
    return dg
end

function noise_var{T}(x::Vector{T}, ψ::T)
    a = TowedArray.params.a
    κ = TowedArray.params.κ
    cosh = cos(convert(Float64,h(x, ψ)))
    σ2 = κ*g(x)/ (cosh*cosh)
    return σ2
end

noise_var(xo::Vector, q::Vector) = noise_var(xo - q[1:4], q[5])

function mes_σ(mm::TARelative)
    (x) -> noise_var(x, sys_ψ(mm))
end

function ∇x_h{T}(x::Vector{T}, sign, ψ::T)
    H = zeros(1,size(x))
    r2 = x[1]*x[1] + x[2]*x[2]
    
    H[1] = -sign*x[2]/r2
    H[2] = -sign*x[1]/r2
    H
end

function mes_∇x_h(mm::TARelative)
    (x) -> ∇x_σ(x, sign, sys_ψ(mm))
end
