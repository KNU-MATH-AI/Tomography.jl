module Radon

export radon
export backprojection, backprojection_anim
export iradon, fitered_backprojection, SART

"""
    radon(f::Matrix{T}, θ::Vector{T}) where {T<:Real}

return Radon transform of `f`

# Keyword arguments

- `f`: phantom
- `θ`: projection angle
"""
function radon(f, θ=0:(π/180):π-π/180)
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

function backprojection(Rf)
    slim, θlim = size(Rf)
    reconstructed_image = zeros(slim, slim)
    
    ylim, xlim = size(reconstructed_image)
    L = round(Int64, hypot(xlim, ylim))
    
    x= range(-xlim/2+1, xlim/2, xlim)
    y= range(ylim/2, -ylim/2+1, ylim)

    X = x'.*ones(xlim)
    Y = ones(ylim)'.*y

    θ = 0 : π/θlim : π-π/θlim
    s = range(-L/2, L/2, length=slim)

    for (value, angle) ∈ zip(eachcol(Rf), θ)
        S = X.*cos(angle) + Y.*sin(angle)
        interpolation = LinearInterpolation(s, value, extrapolation_bc=Line())
        reconstructed_image .+= interpolation.(S)
    end
    return reconstructed_image
end

function backprojection_anim(Rf)
    slim, θlim = size(Rf)
    reconstructed_image = zeros(slim, slim)

    slim, θlim= size(Rf)
    ylim, xlim = size(reconstructed_image)
    L = round(Int64, hypot(xlim, ylim))

    x= range(-xlim/2+1, xlim/2, xlim)
    y= range(ylim/2, -ylim/2+1, ylim)

    X = x'.*ones(xlim)
    Y = ones(ylim)'.*y

    θ = 0 : π/θlim : π-π/θlim
    s = range(-L/2, L/2, length=slim)

    anim = Animation()
    for (value, angle) ∈ zip(eachcol(Rf), θ)
        S = X.*cos(angle) + Y.*sin(angle)
        interpolation = LinearInterpolation(s, value, extrapolation_bc=Line())
        reconstructed_image .+= interpolation.(S)
        frame(anim, heatmap(reverse(reconstructed_image, dims=1)))
    end
    for _ ∈ 1:80
        frame(anim, heatmap(reverse(reconstructed_image, dims=1)))
    end
    return anim
end

function iradon(ℛf, method="fbp")
    
    if method == "fbp"
        reconstructed_f = fitered_backprojection(ℛf)
    end

    return reconstructed_f
end

function fitered_backprojection(ℛf)
    N = size(ℛf)[1]
    
    ℱℛf = fft(ℛf, [1])
    
    fourier_filter = abs.(fftfreq(N))    
    filterd_ℱℛf = ℱℛf .* fourier_filter

    ℱ⁻¹_filterd_ℱℛf = real.(ifft(filterd_ℱℛf, [1]))

    reconstructed_f = (π/360)*backprojection(ℱ⁻¹_filterd_ℱℛf)
    return reconstructed_f
end

function SART(ℛf)
end