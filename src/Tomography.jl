module Tomography

using Plots
using FFTW
using Interpolations

include("phantom.jl")
include("radon.jl")
include("backprojection.jl")
include("wave_forward.jl")

export phantom, radon, iradon, backprojection, backprojection_anim, wave_forward

end # module