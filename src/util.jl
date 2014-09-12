module Utils

export @include_path

macro include_path(path::String)
    return @eval begin
        write(STDERR, "including path $(path): $(readdir($path))\n")
        for f in filter(f -> last(split(f, '.')) == "jl" && f[1] != '.' && f[1] != '#', readdir($path))
            write(STDERR, "include($(joinpath(path,f)))\n")
            include(joinpath($path, f))
        end
    end
end

end
