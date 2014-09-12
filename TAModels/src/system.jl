abstract AbstractSystemModel{T<:Real}
abstract AbstractController

type Controller <: AbstractController
    controller::Task
end

type ControlSystemModel{T} <: AbstractSystemModel{T}
    x::Vector{T}
    dt::T
    controller::Task
end

ControlSystemModel{T}(x0::Vector{T}, dt::T, ctl::Task) = ControlSystemModel{T}(x0, dt, ctl)
ControlSystemModel{T}(x0::Vector{T}, dt::T, u::Function) = ControlSystemModel{T}(x0, dt, Task(u))

function update!{T}(m::ControlSystemModel{T})
    u = consume(m.controller)
    update!(m, consume(m.controller))
end

function stateof(sys::AbstractSystemModel)
    sys.x
end

import Base.show

function show(io::IO, sys::ControlSystemModel)
    print(io, "$(sys.x')")
end
