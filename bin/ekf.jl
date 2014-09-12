using TowedArray, RBE, Models, Distributions, PDMats
using Base.Test

const dt = 0.1

data = readdlm(ARGS[1], ',')

#initialize filter
filt = EKF(gmvnormal(ScalMat(4,1000.0)))

system_ctl = target_u(reshape(data[1,9:13],5), dt)

function iterate{T}(row::Vector{T})
    u = row[3:4]
    target = Target(row[5:8])
    auv = Auv(row[9:13])
    tasys = TARelative(target, auv)
    z = row[14]
    ## do we use tasys as system model, or tasystem which has state = x-q ? probably the latter
    predict!(filt, tasys, system_ctl(stateof(auv), u))
    correct!(filt, tasys, z)
    @show tasys
    println("z: $(row[10])")
end

mapslices(iterate, data, 2)


#filter = EKF(MvNormal())

#apriori = initialize(filter, MvNormal())

#run(filter, apriori, data)

