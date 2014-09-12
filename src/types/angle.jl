immutable Angle <: Real
    dz::Float64
    rad::Bool   # radian representation
    #sym::Bool   # range is symetric ( -pi/2, pi/2 )
end

Angle(x::Number) = Angle(x, true)

convert(::Type{Angle}, ::MathConst{:π}) = Angle(π)
#Angle(x::Number) = convert(Angle, x)

function convert(::Type{Angle}, x::Union(FloatingPoint, Integer)) 
    x = float(x)
    # map value to [-pi, pi]
    while x < -pi
        x += 2pi
    end    
    
    while x > pi
	x -= 2pi
    end
    
    Angle(x, true)
end

convert(::Type{BigFloat}, x::Angle) = convert(BigFloat, x.dz) # resolve ambiguity
convert(::Type{Bool}, x::Angle) = (x.dz != 0)                 # resolve ambiguity
convert{T<:FloatingPoint}(::Type{T}, x::Angle) = convert(T, x.dz)
convert{T<:Integer}(::Type{T}, x::Angle) = convert(T, x.dz)

#promote_rule{T}(::Type{Angle}, ::Type{T}) = Angle
promote_rule(::Type{Angle}, ::Type{Float64}) = Angle

for op in (:+, :-)
    @eval begin
        ($op)(x::Angle, y::Angle) = Angle($(op)(x.dz, y.dz))
    end
end

*(x::Angle, b::Bool) = Angle(x.dz)
*(x::Angle, y::Real) = Angle(x.dz*y)
/(x::Angle, y::Real) = Angle(x.dz/y)

< (x::Angle, y::Angle) = x.dz < y.dz
> (x::Angle, y::Angle) = x.dz > y.dz

import Base.show

function show(io::IO, a::Angle)
    print(io, "$(a.dz)", a.rad ? "rad" : "deg")
end

function degrees(ang::Angle)
    if ang.rad
        360*ang.dz/pi
    else
        ang.dz
    end
end
