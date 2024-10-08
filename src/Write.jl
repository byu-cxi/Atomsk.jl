function writeConfig(config, prefix, fileformats)
    prefix = [Cchar(c) for c in prefix]
    PREFIXSIZE = Ref{Cint}(length(prefix))
    NUMFORMATS = Ref{Cint}(length(fileformats))
    space = Cchar(' ')
    fileformats = [i <= length(fileformats[j]) ? Cchar(fileformats[j][i]) : space for j in 1:length(fileformats) for i in 1:5]
    @ccall libatomsk.run_write(
        config.NUMATOMS::Ref{Cint}, config.P::Ptr{Cdouble}, config.NUMSHELLS::Ref{Cint}, config.S::Ptr{Cdouble},
        config.NUMAUXNAMES::Ref{Cint}, config.AUXNAMES::Ptr{Char}, config.AUX::Ptr{Cdouble},
        config.H::Ptr{Cdouble}, prefix::Ptr{Char}, PREFIXSIZE::Ref{Cint}, fileformats::Ptr{Cchar}, NUMFORMATS::Ref{Cint}
    )::Cvoid
end
