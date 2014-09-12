immutable SystemDistribution
    td::TargetDistribution
    ad::AgentDistribution
end

SystemDistribution() = SystemDistribution(TargetDistribution(), AgentDistribution())

function rand!(d::SystemDistribution, x::Array{Float64,1})
    x[1:4] = rand(d.td)
    x[5:9] = rand(d.ad)
end

function rand(d::SystemDistribution)
    x = zeros(9)
    rand!(d,x)
    x
end
