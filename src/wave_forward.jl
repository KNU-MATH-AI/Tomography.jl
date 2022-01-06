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

function wave_forward_operater(f, x, t, R, N_ϕ)
    N_b = size(f)[1]
    x_end = x[end]
    x2 = 2x_end
    N_t = length(t)        # Number of elements of vector t
    N_x = length(x)        # Number of elements of vector x
    N_x2 = 2N_x
    half_N_x = Int64(N_x/2)
    dt = t[2]-t[1]

    #outer larger grid for solution of wave equation
    g_x = range(-x2, stop=x2 - (2x2)/N_x2, length=N_x2)

    #frequency vectors 
    k = range(-N_x, stop=N_x-1, length=N_x2) .* ( pi / x2)
    K = k.^2 .+ (k.^2)'
    KM2 = ifftshift(K)
    KM = sqrt.(KM2)

    #initial pressure field
    #P = zeros(N_b, N_x2, N_x2)
    #P[:, half_N_x:3half_N_x-1, half_N_x:3half_N_x-1] = f
    P = zeros(N_x2, N_x2)
    P[half_N_x:3half_N_x-1, half_N_x:3half_N_x-1] = f

    # k-space
    #W = zeros(N_b, N_t+1, N_x2, N_x2)
    #W[:, 2, :, :] = P
    #W[:, 1, :, :] = P   #t=-1일 때의 W
    W = zeros(N_x2, N_x2, N_t+1)
    W[:, :, 2] = P
    W[:, :, 1] = P   #t=-1일 때의 W

    detector_angle = 0: 2pi/N_ϕ : 2pi-2pi/N_ϕ
    detector_x = R * cos.(detector_angle)
    detector_y = R * sin.(detector_angle)

    #Wf = zeros(N_b, N_t, N_ϕ)
    Wf = zeros(N_t, N_ϕ)
    sin_term = @. -4(sin(dt*KM/2))^2
    #sin_term = reshape(sin_term, (1,size(sin_term)[1], size(sin_term)[2]))

    #for i ∈ 2:N_t
    #    LW = ifft(sin_term.*fft(W[:, i, :, :]))
    #    real_LW  = real(LW)
    #    W[:, i+1, :, :] = 2W[:, i, :, :] - W[:, i-1,: ,:] + real_LW
    #    #W[:, i+1, :, :] = 2*W[:, i, :, :] - W[:, i-1,: ,:] + cx*LW1
    #                   
    #    Wf[:, i, : ] = interp(g_x, W[:, i+1, :, :], detector_x, detector_y) 
    #end
    for i ∈ 2:N_t
        LW = ifft(sin_term.*fft(W[:, :, i]))
        real_LW  = real(LW)
        W[:, :, i+1] = 2W[:, :, i] - W[:, :, i-1] + real_LW
        #W[:, i+1, :, :] = 2*W[:, i, :, :] - W[:, i-1,: ,:] + cx*LW1
                    
        Wf[i, :] = interp(g_x, W[:, :, i+1], detector_x, detector_y) 
    end
    return Wf, W
end