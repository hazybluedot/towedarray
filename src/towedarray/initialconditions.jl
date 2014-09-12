using TowedArray, TowedArray.Types, TowedArray.Models, TowedArray.Control, TowedArray.Distributions, Iterators


const d = SystemDistribution()

function initialize()
    x = rand(d)

    xt0 = x[1:4]
    xo0 = x[5:9]
    dt = 0.1
    u0 = [1.0,0.015]

    TowedArraySystem(xt0, xo0, dt, @task Control.steady(u0))
end

function icgenerator()
    while true
        produce(initialize())
    end
end

function generate_initialconditions(n::Integer)
    for ic in take(Task(icgenerator), n)
        println("$(join(ic.target.x,',')),$(join(ic.auv.x,','))")
    end
end

