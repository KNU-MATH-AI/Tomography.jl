function backprojection(Rf)
    slim, θlim = size(Rf)
    reconstructed_image = zeros(slim, slim)
    backprojection!(reconstructed_image, Rf)
    return reconstructed_image
end

function backprojection!(reconstructed_image, Rf)
    slim, θlim= size(Rf)
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
    anim = backprojection_anim!(reconstructed_image, Rf)
    return anim
end

function backprojection_anim!(reconstructed_image, Rf)
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