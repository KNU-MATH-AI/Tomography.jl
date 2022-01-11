using Documenter
using Tomography

makedocs(
    sitename = "Tomography.jl",
    format = Documenter.HTML(),
    modules = [Tomography],
    pages = [
        "Home" => "index.md",
        ]
)

deploydocs(
    repo = "github.com/KNU-MATH-AI/Tomography.jl",
    target = "build",
    deps = nothing,
    make = nothing,
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
