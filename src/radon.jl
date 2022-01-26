function radon_test(f, θ=0:(π/180):π-π/180)
    ℛf = zeros(maximum(size(f)), length(θ))

    slim, θlim = size(ℛf)
    ylim, xlim = size(f)
    L = round(Int64, hypot(xlim, ylim))
    
    cos_ = cos.(θ)
    sin_ = sin.(θ)

    S = LinRange(-L/2, L/2, slim)
    T = LinRange(-L/2, L/2, L)
    
    for sᵢ ∈ 1:slim, θᵢ ∈ 1:θlim
        for l ∈ 1:L
            x = round(Int64, xlim/2 + S[sᵢ]*cos_[θᵢ] + T[l]*sin_[θᵢ])
            y = round(Int64, ylim/2 - T[l]*cos_[θᵢ] + S[sᵢ]*sin_[θᵢ])
            if 1 ≤ x ≤ xlim && 1 ≤ y ≤ ylim
                ℛf[sᵢ, θᵢ] += f[end-y+1, x]
            end
        end
    end
    
    return ℛf
end