using Documenter
using Tomography

makedocs(
    sitename = "Tomography.jl",
    format = Documenter.HTML(),
    modules = [Tomography],
    pages = Any[
        "Home" => "index.md",
        "Phantom" => "phantom.md",
        "Radon Transform" => "radon.md"
        ]
)

deploydocs(
    repo = "github.com/KNU-MATH-AI/Tomography.jl.git",
    target = "build",
    make = nothing,
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
