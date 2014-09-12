module Types

export Angle, SignedMeasurement

import Base: convert, show, promote_rule

include(joinpath("types","angle.jl"))
include(joinpath("types","signedhalfangle.jl"))

end
