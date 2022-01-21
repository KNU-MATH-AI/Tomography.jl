using SpecialFunctions
using LinearAlgebra # 그냥 L2놈만 따로 정의하는 게 편할 수 있다


function λ(κ,m, μ,ψ; n=1)
    cosψ = cos(ψ)
    tanψ = tan(ψ)
    if n != 1
        numerator = 2^n * π^((n-1)/2) * (1 + (μ / cosψ) - m*im ) * gamma((n+1)/2) * ((tanψ)^(n-1))
        denominator = ((1 + (μ / cosψ) - m*im )^2 + (norm(κ,2) * tanψ)^2)^((n+1)/2) * cosψ
    elseif n == 1
        numerator = 2 * ((μ / cosψ) - m*im )
        denominator = (((μ / cosψ) - m*im )^2 + (norm(κ,2) * tanψ)^2) * cosψ
    end
    return numerator / denominator
end

# function Ψ(κ,m, x,z)
#     return exp(1im * (κ'x + (m*z))) * exp(-z)
# end

function Φ(κ,m, x,z)
    return exp((κ'x + (m*z)) * im)
end


# function innerprod_e2z(f,g,z; n=1)
#     a = size(f)[1] ÷ 2
#     return sum(f .* conj(g) .* exp.(2(ones(2a,2a) .* LinRange(-a,a, 2a))') ) / ((2a)^(n+1))
# end