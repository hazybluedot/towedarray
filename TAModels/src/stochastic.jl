using Distribution

type StochasticModel{T} <: SystemModel{T}
     p::Distribution
end 
