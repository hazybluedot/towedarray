module TAModels

using Models, Distributions, PDMats

import Models: sys_f, sys_g, sys_∇x_f, sys_∇x_g, sys_N, stateof

export 
       # types

       Target, 
       Auv,
       TASystem,
       TARelative,

       # methods

       predict_measurement,
       sim_measurement,
       target_u

include("auv.jl")
include("measurement.jl")
include("target.jl")
include("tasystem.jl")
include("relative.jl")

end
