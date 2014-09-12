push!(LOAD_PATH, pwd())

module TowedArray

using Models

export 
  Auv,
  Target,
  TARelative,
  params,
  target_u

immutable ArrayParams
    d::Real     # distance between hydrophones
    N::Integer  # number of hydrophones
    a::Vector{Float64}
    κ::Float64
end

immutable SourceParams
    a::Real     # amplitude
    f::Real     # frequency (Hz)
end

const params = ArrayParams(0.048, 8, [0.0305, 0.0015, 40.0], 5.39e-3)
const sparams = SourceParams(1,32e3)
const c = 1497 # speed of sound in water

include("types.jl")
include("controllers.jl")

using TAModels

module Distributions

using Distributions.Uniform

import Distributions: gmvnormal
import Distributions: Normal, IsoNormal
import PDMats: ScalMat
import Base: rand, rand!

export 
   MvUniform, 
   AgentDistribution, 
   TargetDistribution,
   SystemDistribution

using PDMats

include(joinpath("towedarray","distributions","mvuniform.jl"))
include(joinpath("towedarray","distributions","agent.jl"))

typealias TargetDistribution MvUniform

TargetDistribution() = TargetDistribution( [ -40 40; -40 40; -2 2; -2 2 ] )

include(joinpath("towedarray","distributions","system.jl"))

end


include(joinpath("towedarray","initialconditions.jl"))
include(joinpath("towedarray","simulate.jl"))

end
