type Auv <: AbstractModel
    x::Vector
    dt::Float64

    Auv(x,dt) = length(x) != 5 ? error("length of initial condition vector must be 5") : new(x,dt)
end

Auv(x::Vector) = Auv(x, 1.0)
Auv(dt::Number) = Auv(zeros(5), float(dt))

function sys_f(m::Auv)
    return function(x,u) 
        x[1] = x[1] + m.dt*x[3];
        x[2] = x[2] + m.dt*x[4];
        x[3] = u[1]*cos(x[5]);
        x[4] = u[1]*sin(x[5]);
        x[5] = x[5] + m.dt*u[2];
        x
    end
end


