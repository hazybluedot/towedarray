type TARelative <: AbstractLinearModel
    x::Vector
    ψ::Float64
    dt::Float64
    N::IsoNormal

    function TARelative(x, ψ, dt, N) 
        length(x) != 4 && error("state vector must be lenght 4")
        dt <= 0 && error("dt must be positive")
        new(x,ψ,dt,N)
    end
end

function target_u(q0::Vector, dt_::Number)
    m_q = q0
    const dt = dt_
    return function(q::Vector, u::Vector)
        u = zeros(4)
        u[1] = m_q[1] + dt*m_q[3] - q[1]
        u[2] = m_q[1] + dt*m_q[4] - q[2]
        u[3] = m_q[3] - q[3]
        u[4] = m_q[4] - q[4]
        m_q = q
        u
    end
end

TARelative(dt::Number) =   TARelative(zeros(4), 0.0, dt, gmvnormal( ScalMat(2, 1.0) ))
TARelative(x::Vector, ψ::Float64) = TARelative(x, ψ, 1.0, gmvnormal( ScalMat(2, 1.0) ))
TARelative(xt::Vector, xa::Vector) = TARelative( xa[1:4] - xt, xa[5])
TARelative(tm::Target, am::Auv) = TARelative( stateof(am)[1:4] - stateof(tm), stateof(am)[5])

function sys_A(t::TARelative)
    A = eye(4)
    A[1,3] = t.dt
    A[2,4] = t.dt
    A
end

function sys_Γ(t::TARelative)
    Γ = vcat(eye(2)*t.dt^2/2, eye(2)*t.dt)
    Γ
end

function sys_f(t::TARelative)
    A = sys_A(t)
    (x,u) -> A*x - u
end

function sys_∇x_f(t::TARelative)
    (x,u) -> sys_A(t)
end

function sys_g(t::TARelative)
    ω -> sys_Γ(t)*ω
end

function sys_∇x_g(t::TARelative)
    (x) -> sys_Γ(t)
end

function sys_ψ(t::TARelative)
    t.ψ
end
    
function sys_N(t::TARelative)
    t.N
end
