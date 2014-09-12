immutable AgentDistribution
    position::IsoNormal
    speed::Normal
    heading::Uniform
end

AgentDistribution() = AgentDistribution(gmvnormal( ScalMat(2, 1.0) ), Normal(1, 0.5), Uniform(-pi, pi) )
        
function speedMap(x)
    x[1] = x[1]*cos(x[3])
    x[2] = x[1]*sin(x[3])
    x
end

function rand!(d::AgentDistribution, x::Array{Float64,2})
    x[1:2,:] = rand(d.position, size(x,2))
    x[3,:] = rand(d.speed, size(x,2))
    x[5,:] = rand(d.heading, size(x,2))
    #rand!(d.position, x[1:2,:])
    #rand!(d.speed, x[3,:])
    #rand!(d.heading, x[5,:])
    for i in 1:size(x,2)
        x[3:5,i] = speedMap(x[3:5,i])
    end
end

function rand!(d::AgentDistribution, x::Array{Float64,1})
    x[1:2] = rand(d.position)
    x[3] = rand(d.speed)
    x[5] = rand(d.heading)
    x[3:5] = speedMap(x[3:5])
    x
end

function rand(d::AgentDistribution)
    x = zeros(5)
    rand!(d,x)
    x
end
