using Documenter
using Tomography

makedocs(
    sitename = "Tomography",
    format = Documenter.HTML(),
    modules = [Tomography]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
