using Base.Test, TowedArray.Models, TowedArray.Types, TowedArray

x0 = [0.0, 0.0, 0.5, 0.5]
dt = 0.1
#target = Target(x0, dt)

target = Target(x0, dt)

@show target.x

@test target.x == x0

update!(target)

@show target.x

@test target.x == [dt*0.5, dt*0.5, 0.5, 0.5]
