using TowedArray.Types, Distributions

typealias TowedArraySystem ModelArray

type TASystem <: AbstractModelArray
    models::ModelArray

    TASystem(ma::ModelArray) = all(map(x -> x.dt == ma[1].dt, ma)) ? new(ma) : error("unmatched sample times unsupported")
end

TASystem(xt0::Vector, xo0::Vector) = TASystem( ModelArray([ Target(xt0), Auv(xo0) ], ["target", "auv"]) )


function predict_measurement(sys::TowedArraySystem)
    TowedArray.h(sys.models[1].x, sys.models[2].x)
end

function sim_measurement(sys::TowedArraySystem, s::SignedMeasurement)
    s.dz + sim_measurement_noise(sys)
end

sim_measurement(sys::TowedArraySystem) = sim_measurement(sys, predict_measurement(sys))

function sim_measurement_noise(sys::TowedArraySystem)
    randn()*sqrt(TowedArray.noise_var(sys.models[1].x, sys.models[2].x))
end

