"""
    create(lattConst, structType, species, NT_mn, millerIndices)

Create an atomic configurations. Lattice constants are a vector of 3 Float64s, 
structure type is a string of the type of configuration (e.g. fcc, bcc, etc.), 
species is vector of strings that gives the element name of the atoms (e.g.
["Cs","Cl"], NT_mn gives the `m` and `n` integers if a nanotube is selected, 
and Miller indices are vectors of integers that define the orientation of
the system.
"""
function create(lattConst, structType, species, NT_mn, millerIndices)
    space = Cchar(' ')
    lattConst = Cdouble.(lattConst)
    structType = [i <= length(structType) ? Cchar(structType[i]) : space for i in 1:10]
    species = [j <= length(species) && i <= length(species[j]) ? Cchar(species[j][i]) : space for j in 1:20 for i in 1:2]
    NT_mn = Cint.(NT_mn)
    NUMOPTIONS = Ref{Cint}(0)
    options_array = Cchar[]
    NUMATOMS = Ref{Cint}(0)
    POUT = Ref{Ptr{Cdouble}}()
    H = zeros(Cdouble,3,3)
    millers = replace.(string.(millerIndices), ","=>""," "=>"")
    millers = [j <= length(millers) && i <= length(millers[j]) ? Cchar(millers[j][i]) : space for j in 1:3 for i in 1:32]
    @ccall libatomsk.run_create(
        lattConst::Ptr{Cdouble}, structType::Ptr{Cchar}, species::Ptr{Cchar}, NT_mn::Ptr{Cint}, millers::Ptr{Cchar},
        NUMOPTIONS::Ref{Cint}, options_array::Ptr{Cchar}, NUMATOMS::Ref{Cint}, POUT::Ref{Ptr{Cdouble}}, H::Ptr{Cdouble}
    )::Cvoid

    newP = unsafe_wrap(Array, POUT[], Int(NUMATOMS[])*4)
    P = copy(newP)

    @ccall libatomsk.deallocate_create(POUT::Ref{Ptr{Cdouble}})::Cvoid

    return Configuration(P, H, NUMATOMS[])
end

"""
    polycrystal(seed, box, nodes)

Create a polycrystal. The seed is a Configuration object (both the polycrystal 
and create functions return Configuration objects) that defines the the basis
of all grains. The box is a vector of 3 integers that bounds the polycrystal,
and the nodes give the locations and orientations of all grains in the polycrystal. 
"""
function polycrystal(seed, box, nodes)
    seedFile = tempname()
    polyFile = tempname()
    fileformats = ["cfg"]
    writeConfig(seed, seedFile, fileformats)
    open(polyFile,"w") do io
        println(io, "box ",join(box," "))
        for n in nodes
            println(io, "node ",join(replace.(string.(n), ","=>""," "=>"")," "))
        end
    end

    seedFile *= ".cfg"
    seedFileArray = [Cchar(c) for c in seedFile]
    seedFileSize = Ref{Cint}(length(seedFileArray))
    polyFileArray = [Cchar(c) for c in polyFile]
    polyFileSize = Ref{Cint}(length(polyFileArray))
    NUMOPTIONS = Ref{Cint}(0)
    options_array = Cchar[]
    NUMATOMS = Ref{Cint}(0)
    POUT = Ref{Ptr{Cdouble}}()
    H = zeros(Cdouble,3,3)
    @ccall libatomsk.run_polycrys(
        seedFileArray::Ptr{Cchar}, seedFileSize::Ref{Cint}, 
        polyFile::Ptr{Cchar}, polyFileSize::Ref{Cint},
        NUMOPTIONS::Ref{Cint}, options_array::Ptr{Cchar}, 
        NUMATOMS::Ref{Cint}, POUT::Ref{Ptr{Cdouble}}, H::Ptr{Cdouble}
    )::Cvoid

    newP = unsafe_wrap(Array, POUT[], Int(NUMATOMS[])*4)
    P = copy(newP)

    @ccall libatomsk.deallocate_polycrys(POUT::Ref{Ptr{Cdouble}})::Cvoid
    rm(seedFile)
    rm(polyFile)

    return Configuration(P, H, NUMATOMS[])
end
