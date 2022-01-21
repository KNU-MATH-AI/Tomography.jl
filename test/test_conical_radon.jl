using Plots

include("../src/conical_radon.jl")
include("../src/inv_conical_radon.jl")
include("../src/util.jl")
include("../src/phantom.jl")

function innerprod(f,g)
    a = 1
    return sum(f .* conj(g)) / ((2a)^2)
end

ϕ = π/4
μ = 1

# target = rand(100,100)^0
target = phantom(100,2)

Cμf = conical_radon(target, ϕ, μ)
plot(heatmap(target),heatmap(reverse(Cμf, dims=1)), size = (1000,400))

begin
X,Z = size(Cμf)
n = length(size(Cμf))
f = zeros(ComplexF64,X,Z)

# @time for κ in [100], m in [100]
@time for t in 1:10000
    κ = .1randn()
    m = .1randn()

    Φ_κm = zeros(ComplexF64,X,Z)

    for x in 1:X, z in 1:Z
        Φ_κm[x,z] = Φ(κ,m, x,z)
    end
    # cplx_heatmap(Φ_κm)
    f += (Φ_κm .* (innerprod(Cμf,Φ_κm)/λ(κ,m, μ,ϕ)))
end
cplx_heatmap(f)
end

# Φ_κm = zeros(ComplexF64,I,J)
# for x in 1:I, z in 1:J
#     Φ_κm[x,z] = Φ(10.3,25.5, x/200-1,z/200-1)
# end
# cplx_heatmap(Φ_κm)
