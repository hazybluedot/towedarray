abstract AbstractMvUniform

immutable MvUniform <: AbstractMvUniform
    d::Array{Uniform,1}
    dim::Int

end

MvUniform(d::Array{Uniform,1}) = MvUniform(d, length(d))

function MvUniform(ranges::Array{Float64,2})
    MvUniform([ Uniform(ranges[i,1], ranges[i,2]) for i in 1:size(ranges,1)])
end

function MvUniform(ranges::Array{Int64,2})
    MvUniform([ Uniform(ranges[i,1], ranges[i,2]) for i in 1:size(ranges,1)])
end

function rand!{T<:Real}(d::MvUniform, x::Array{T,1})
    broadcast!(rand, x, d.d)
end

function rand(d::MvUniform, x::Array{Float64,2})
    for i in 1:size(x,2)
        x[:,i] = rand!(d, x[:,i])
    end
    x
end

function rand(d::MvUniform)
    #[ rand(md) for md in d.d ]
    x = zeros(length(d.d))
    rand!(d,x)
    x
end

function rand(d::MvUniform, n::Integer)
    x = zeros(length(d.d), n)
    rand!(d,x)
    x
end
