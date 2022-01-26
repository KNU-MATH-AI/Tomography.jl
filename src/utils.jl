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

function interp_nd(G, P, X, Y)
iv = zeros(size(P)[1], length(X))
for i ∈ 1:length(X)
    index_x = argmin(abs.(G.-X[i]))
    index_y = argmin(abs.(G.-Y[i]))

    iv[:, i] = P[:, index_y, index_x]
end
return iv
end

function interp(G, P, X, Y)
iv = zeros(length(X))
for i ∈ 1:length(X)
    index_x = argmin(abs.(G.-X[i]))
    index_y = argmin(abs.(G.-Y[i]))

    iv[i] = P[index_y, index_x]
end
return iv
end    