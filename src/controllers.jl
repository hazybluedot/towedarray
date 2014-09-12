module Control
function steady(u::Vector)
    while true
        produce(u)
    end
end
end
