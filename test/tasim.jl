using Base.Test, TowedArray

xt0 = [0.0, 0.0, 0.5, 0.75]
xo0 = [10.0, 5.0, 0.5, 0.5, 0.0]
dt = 0.1
u0 = [ fill(NaN,2) [1.0,0.015] ]
tasys = make_tasys(xt0, xo0)

println(tasys)

for i=1:5
    update!(tasys, u0)
    s = predict_measurement(tasys)
    z = sim_measurement(tasys)
    df = DataFrame(AUV = tasys.auv.x', target = tasys.target.x')
    println(df)
    #println("($(tasys.auv.x')), $(s), $(z)")
end
