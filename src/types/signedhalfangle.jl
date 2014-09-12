immutable SignedMeasurement
    dz::Angle
    sign::Int8

    SignedMeasurement(z::Angle, s::Int8) = (s == 1 || s == -1) ? new(z,s) : error("sign must be 1 or -1")
end

SignedMeasurement(z::Angle, s::Integer) = SignedMeasurement(z, convert(Int8,s))
SignedMeasurement(z::Float64, s::Integer) = SignedMeasurement(convert(Angle,z), convert(Int8,s))

import Base.convert

function convert(Angle, sm::SignedMeasurement)
    return sm.dz*sm.sign
end

import Base.show

function show(io::IO, sz::SignedMeasurement)
    print(io, "SignedHalfAngle: $(sz.dz) ($(sz.sign))")
end
