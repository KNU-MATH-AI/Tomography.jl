using Plots

function cplx_heatmap(M)
    plot(
        heatmap(abs.(M)),
        heatmap(real.(M)),
        heatmap(imag.(M)),
        layout = (1,3),
        size = (1600,400)
    )
end

