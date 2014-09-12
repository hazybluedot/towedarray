function signal()
    ω = 2pi*sparams.f
    α = (ω/c)params.d
    res = cell(params.N)
    φ = 0
    for k=1:params.N
        res[k] = (t,Θ)->sparams.a*sin(ω*t + φ - k*α*sin(Θ))
    end
    res
end 

xk = signal()

function x(t,Θ)
    res = zeros(Float64, length(xk))
    [ xk[i](t,Θ) for i in 1:length(xk) ]
end

function fill_samples!(a::Array{Float64,2}, ts, Θ::Float64)
    for t in ts
        a[:,t+1] = x(t, Θ)
    end
end

function cycles(n::Integer=1, sps::Integer=7812)
    a = Array(Float64, 8, sps+1)
    TowedArray.fill_samples!(a, 0:sps, 0.0)
    a
end
