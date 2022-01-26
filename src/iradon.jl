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