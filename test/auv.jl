using TowedArray

using Base.Test

const x0 = [0.0, 0.0, 0.5, 0.5, 0.0]
dt = 0.1
u0 = [1.0,0.015]

const auv_controller = @task TowedArray.Control.steady(u0)

auv = Auv(x0)

@test auv.x == x0

x = x0

println(auv)

update!(auv, consume(auv_controller))

println(auv)
#for i=1:5
#    update!(auv)
#    TowedArray.Models.Auv.f!(x, u0, dt)
#    @test x == auv.x
#end
#@test target.x == [dt*0.5, dt*0.5, 0.5, 0.5]
