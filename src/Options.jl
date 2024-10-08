function addOptions(config, options)
    space = Cchar(' ')
    options_array = fill(space, 128)
    ind = 1
    for o in options
        for c in o
            options_array[ind] = Cchar(c)
            ind += 1
        end
        ind += 1
    end
    append!(config.options_array, options_array)
end

function addatom(config, args...)
    options = ["-add-atom", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function addshells(config, species)
    options = ["-add-shells",species]
    addOptions(config, options)
end

function alignx(config)
    options = ["-alignx"]
    addOptions(config, options)
end

function bindshells(config)
    options = ["-bind-shell"]
    addOptions(config, options)
end

function cell(config, args...)
    options = ["-cell", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function center(config, args...)
    options = ["-center", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function crack(config, args...)
    options = ["-crack", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function cut(config, args...)
    options = ["-cut", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function deform(config, args...)
    options = ["-deform", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function dislocation(config, args...)
    options = ["-dislocation", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function disturb(config, args...)
    options = ["-disturb", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function duplicate(config, args...)
    options = ["-duplicate", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function fix(config, args...)
    options = ["-fix", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function fractional(config)
    options = ["-fractional"]
    addOptions(config, options)
end

function mirror(config, args...)
    options = ["-mirror", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function orient(config, args...)
    options = ["-orient", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function orthogonalcell(config)
    options = ["-orthogonal-cell"]
    addOptions(config, options)
end

function rebox(config)
    options = ["-rebox"]
    addOptions(config, options)
end

function reducecell(config, args...)
    options = ["-reduce-cell", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function removeatom(config, args...)
    options = ["-remove-atom", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function removedoubles(config, args...)
    options = ["-remove-doubles", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function removeproperty(config, args...)
    options = ["-remove-property", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function removeshells(config, args...)
    options = ["-remove-shells", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function roll(config, args...)
    options = ["-roll", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function rotate(config, args...)
    options = ["-rotate", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function roundoff(config, args...)
    options = ["-round-off", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function select(config, args...)
    options = ["-select", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function separate(config, args...)
    options = ["-separate", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function shift(config, args...)
    options = ["-shift", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function sort(config, args...)
    options = ["-sort", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function spacegroup(config, args...)
    options = ["-spacegroup", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function stress(config, args...)
    options = ["-stress", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function substitute(config, args...)
    options = ["-substitute", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function swap(config, args...)
    options = ["-swap", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function torsion(config, args...)
    options = ["-torsion", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function unit(config, args...)
    options = ["-unit", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function unskew(config)
    options = ["-unskew"]
    addOptions(config, options)
end

function velocity(config, args...)
    options = ["-velocity", replace.(string.(args), ","=>""," "=>"")...]
    addOptions(config, options)
end

function wrap(config)
    options = ["-wrap"]
    addOptions(config, options)
end
