type MultiVariateFunction
    f::Vector{Function}
end

import Base.apply
import Base.getindex

getindex(mvf::MultiVariateFunction, i::Integer) = mvf.f[i]
apply(mvf::MultiVariateFunction, args...) = [ apply(f, args) for f in mvf.f ]
