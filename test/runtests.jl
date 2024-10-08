using Atomsk
using Test
using LinearAlgebra

@testset "Atomsk.jl" begin
    # Test create
    lattConst = [2,2,2]
    structType = "fcc"
    species = ["Al"]
    NT_mn = [0,0]
    orientation = [[1,0,0],[0,1,0],[0,0,1]]
    tester = zeros(4,4)
    tester[2,1:2] .= 1
    tester[3,2:3] .= 1
    tester[4,1] = 1
    tester[4,3] = 1
    tester[:,4] .= 13
    config = create(lattConst, structType, species, NT_mn, orientation)
    testee = config.atoms
 
    @test all(isapprox.(tester, testee))

    # Test addatom
    n = 50
    P = rand(n, 4)
    P[:,4] .= 1
    newAt = [rand(), rand(), rand()]
    tester = zeros(n+1,4)
    tester[1:n,:] .= P
    tester[n+1,1:3] .= newAt
    tester[n+1,4] = 13

    config = Atomsk.Configuration()
    resize!(config.P, length(P))
    config.P .= vec(P)
    config.NUMATOMS[] = n
    addatom(config, "Al", "at", newAt[1], newAt[2], newAt[3])
    testee = config.atoms

    @test all(isapprox.(tester, testee)) 
end
