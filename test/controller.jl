using TowedArray.Control

u0 = [1.0, 0.0]

steady = @task Control.steady(u0)

for i in 1:10
    @test consume(steady) == u0
end
