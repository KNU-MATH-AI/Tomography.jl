using SpecialFunctions
# using LinearAlgebra

l2norm(x) = sqrt(sum(abs2, x))

function λ(κ,m, μ,ψ; n=1)
    cosψ = cos(ψ)
    tanψ = tan(ψ)
    if n != 1
        numerator = 2^n * π^((n-1)/2) * ((μ / cosψ) - m*im ) * gamma((n+1)/2) * ((tanψ)^(n-1))
        denominator = (((μ / cosψ) - m*im )^2 + (l2norm(κ) * tanψ)^2)^((n+1)/2) * cosψ
    elseif n == 1
        numerator = 2 * ((μ / cosψ) - m*im )
        denominator = (((μ / cosψ) - m*im )^2 + (l2norm(κ) * tanψ)^2) * cosψ
    end
    return numerator / denominator
end

function Φ(κ,m, x,z)
    return exp((κ'x + (m*z)) * im)
end