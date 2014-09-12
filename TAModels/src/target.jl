type Target <: AbstractModel
    x::Vector
    dt::Float64

    Target(x,dt) = length(x) != 4 ? error("length of initial condition vector must be 4") : new(x,dt)
end

Target(x::Vector) = Target(x, 1.0)
Target(dt::Number) = Target(zeros(4), float(dt))

function sys_f(m::Target)
    A = eye(4)
    A[1,3] = m.dt
    A[2,4] = m.dt
    return function(x::Array{Float64})
        x = A*x
        x
    end    
end 


