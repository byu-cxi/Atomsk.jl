module Atomsk
    using Preferences
    import Atomsk_jll
    import Atomsk_jll: libatomsk
    
    include("Modes.jl")
    include("Options.jl")
    include("Write.jl")

    export create
    export polycrystal
    export addatom
    export addshells
    export alignx
    export bindshells
    export cell
    export center
    export crack
    export cut
    export deform
    export dislocation
    export disturb
    export duplicate
    export fix
    export fractional
    export mirror
    export orient
    export orhtogonalcell
    export rebox
    export reducecell
    export removeatom
    export removedoubles
    export removeproperty
    export removeshells
    export roll
    export rotate
    export roundoff
    export select
    export separate
    export shift
    export sort
    export spacegroup
    export stress
    export substitute
    export swap
    export torsion
    export unit
    export unskew
    export velocity
    export wrap

    struct Configuration
        options_array::Vector{Cchar}
        Huc::Matrix{Cdouble}
        H::Matrix{Cdouble}
        P::Vector{Cdouble}
        S::Vector{Cdouble}
        AUXNAMES::Vector{Cchar}
        AUX::Vector{Cdouble}
        ORIENT::Matrix{Cdouble}
        SELECT::Vector{Cint}
        C_tensor::Matrix{Cdouble}
        NUMATOMS::Ref{Cint}
        NUMSHELLS::Ref{Cint}
        NUMAUXNAMES::Ref{Cint}

        function Configuration()
            options_array = []
            Huc = zeros(Cdouble,3,3)
            H = zeros(Cdouble,3,3)
            P = []
            S = []
            AUXNAMES = []
            AUX = []
            ORIENT = zeros(Cdouble,3,3)
            SELECT = []
            C_tensor = zeros(Cdouble,9,9)
            new(
                options_array,Huc,H,P,S,AUXNAMES,AUX,ORIENT,
                SELECT,C_tensor,0,0,0
            )
        end

        function Configuration(P, H, ORIENT, NUMATOMS)
            options_array = []
            Huc = zeros(Cdouble,3,3)
            S = []
            AUXNAMES = []
            AUX = []
            SELECT = []
            C_tensor = zeros(Cdouble,9,9)
            new(
                options_array,Huc,H,P,S,AUXNAMES,AUX,ORIENT,
                SELECT,C_tensor,NUMATOMS,0,0
            )
        end

        function Configuration(P, H, NUMATOMS)
            options_array = []
            Huc = zeros(Cdouble,3,3)
            S = []
            AUXNAMES = []
            AUX = []
            ORIENT = zeros(Cdouble,3,3)
            SELECT = []
            C_tensor = zeros(Cdouble,9,9)
            new(
                options_array,Huc,H,P,S,AUXNAMES,AUX,ORIENT,
                SELECT,C_tensor,NUMATOMS,0,0
            )
        end
    end

    function Base.getproperty(config::Configuration, sym::Symbol)
        if sym != :options_array && sym != :P && sym != :S && sym != :AUX && 
           sym != :SELECT && length(config.options_array) != 0
            runAtomsk(config)
        end
        if sym == :atoms
            numatoms = Int64(getfield(config,:NUMATOMS)[])
            return Float64.(reshape(copy(getfield(config, :P)), numatoms, 4))
        elseif sym == :shells
            numshells = Int64(getfield(config,:NUMSHELLS)[])
            return Float64.(reshape(copy(getfield(config, :S)), numshells, 4))
        elseif sym == :auxvars
            numatoms = Int64(getfield(config,:NUMATOMS)[])
            numauxnames = Int64(getfield(config,:NUMAUXNAMES)[])
            return Float64.(reshape(copy(getfield(config, :AUX)), numatoms, numauxnames))
        elseif sym == :auxvarnames
            retVal = Char.(copy(getfield(config, :AUXNAMES)))
            numauxnames = Int64(getfield(config,:NUMAUXNAMES)[])
            return [join(retVal[128*k+1:128*(k+1)]) for k in 0:numauxnames-1]
        else
            return getfield(config, sym)
        end
    end

    function runAtomsk(c::Configuration)
        NUMOPTIONS = div(length(c.options_array),128)
        NUMATOMS = getfield(c, :NUMATOMS)
        POUT = Ref{Ptr{Cdouble}}()
        NUMSHELLS = getfield(c, :NUMSHELLS)
        SOUT = Ref{Ptr{Cdouble}}()
        NUMAUXNAMES = getfield(c, :NUMAUXNAMES)
        AUXNAMES = getfield(c, :AUXNAMES)
        AUXOUT = Ref{Ptr{Cdouble}}()
        Huc = getfield(c, :Huc)
        H = getfield(c, :H)
        ORIENT = getfield(c, :ORIENT)
        C_tensor = getfield(c, :C_tensor)
        SELECTOUT = Ref{Ptr{Cint}}()

        @ccall libatomsk.run_options(
            NUMOPTIONS::Ref{Cint}, c.options_array::Ptr{Cchar},
            NUMATOMS::Ref{Cint}, c.P::Ptr{Cdouble}, POUT::Ref{Ptr{Cdouble}}, 
            NUMSHELLS::Ref{Cint}, c.S::Ptr{Cdouble}, SOUT::Ref{Ptr{Cdouble}},
            NUMAUXNAMES::Ref{Cint}, AUXNAMES::Ptr{Cchar}, c.AUX::Ptr{Cdouble}, AUXOUT::Ref{Ptr{Cdouble}},
            Huc::Ptr{Cdouble}, H::Ptr{Cdouble}, ORIENT::Ptr{Cdouble}, 
            c.SELECT::Ptr{Cint}, SELECTOUT::Ref{Ptr{Cint}}, C_tensor::Ptr{Cdouble}
        )::Cvoid

        resize!(c.options_array, 0)

        newP = unsafe_wrap(Array, POUT[], Int(c.NUMATOMS[])*4)
        resize!(c.P, length(newP))
        c.P .= newP
        newS = unsafe_wrap(Array, SOUT[], Int(c.NUMSHELLS[])*4)
        resize!(c.S, length(newS))
        c.S .= newS
        newAUX = unsafe_wrap(Array, AUXOUT[], Int(c.NUMATOMS[]*c.NUMAUXNAMES[]))
        resize!(c.AUX, length(newAUX))
        c.AUX .= newAUX
        newSELECT = unsafe_wrap(Array, SELECTOUT[], Int(c.NUMATOMS[]))
        resize!(c.SELECT, length(newSELECT))
        c.SELECT .= newSELECT

        @ccall libatomsk.deallocate_options(
            POUT::Ref{Ptr{Cdouble}}, SOUT::Ref{Ptr{Cdouble}}, 
            AUXOUT::Ref{Ptr{Cdouble}}, SELECTOUT::Ref{Ptr{Cint}}
        )::Cvoid

        return
    end

"""
    locate()

Locate the Atomsk library currently being used
"""
locate() = API.LAMMPS_jll.get_liblammps_path()

"""
    set_library!(path)

Change the library path used for `libatomsk.so` to `path`.

!!! note
    You will need to restart Julia to use the new library.

!!! warning
    Due to a bug in Julia (until 1.6.5 and 1.7.1), setting preferences in transitive dependencies
    is broken (https://github.com/JuliaPackaging/Preferences.jl/issues/24). To fix this either update
    your version of Julia, or add LAMMPS_jll as a direct dependency to your project.
"""
    function set_library!(path)
        if !ispath(path)
            error("Atomsk library path $path not found")
        end
        set_preferences!(
            API.Atomsk_jll,
            "liblammps_path" => realpath(path);
            force=true,
        )
        @warn "Atomsk library path changed, you will need to restart Julia for the change to take effect" path

        if VERSION <= v"1.6.5" || VERSION == v"1.7.0"
            @warn """
            Due to a bug in Julia (until 1.6.5 and 1.7.1), setting preferences in transitive dependencies
            is broken (https://github.com/JuliaPackaging/Preferences.jl/issues/24). To fix this either update
            your version of Julia, or add LAMMPS_jll as a direct dependency to your project.
            """
        end
    end
end
