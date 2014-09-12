using Base.Test, TowedArray.Control, TowedArray.Types, TowedArray.Models, TowedArray

function simcb(sys::AbstractModel, f::Function, n::Integer)
    for i=1:n
        s = predict_measurement(sys)
        z = sim_measurement(sys)
        f(stateof(sys), s, z)
        update!(sys)
    end
end

function simcb(sys::AbstractModel, ctrl::Function, f::Function, n::Integer)
    for i=1:n
        s = predict_measurement(sys)
        z = sim_measurement(sys)
        x = stateof(sys)
        u = ctrl(x)
        f(x, u, s, z)
        update!(sys, u)
    end
end

function printsys{T}(x::Array{T,1}, s::SignedMeasurement, z::Angle)
    println("$(join(x,',')),$(s.dz.dz),$(z.dz)")
end
