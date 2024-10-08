using Documenter, Atomsk

makedocs(
    sitename="Atomsk.jl",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    pages = [
        "Atomsk"=>"index.md",
    ],
)

deploydocs(
    repo = "github.com/byu-cxi/Atomsk.jl.git",
)
