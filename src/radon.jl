function radon(f)
    Rf = zeros(maximum(size(f)), 180)
    radon!(Rf, f)
    return Rf
end

function radon!(Rf, f)
    slim, θlim = size(Rf)
    ylim, xlim = size(f)
    L = round(Int64, hypot(xlim, ylim))

    cos_ = cos.(0:(π/θlim):π-π/θlim)
    sin_ = sin.(0:(π/θlim):π-π/θlim)
    S = LinRange(-L/2, L/2, slim)
    T = LinRange(-L/2, L/2, L)
    
    for s ∈ 1:slim, θ ∈ 1:θlim
        for l ∈ 1:L
            x = round(Int64, xlim/2 + S[s]*cos_[θ] + T[l]*sin_[θ])
            y = round(Int64, ylim/2 - T[l]*cos_[θ] + S[s]*sin_[θ])
            if 1 ≤ x ≤ xlim && 1 ≤ y ≤ ylim
                Rf[s, θ] += f[end-y+1, x]
            end
        end
    end
    
    return Rf
end