function padding(p)
    
    θlim, slim = size(p);    
    θ_left = Int(θlim/2+1);
    θ_right = Int(θlim/2+θlim);
    s_left = Int(slim/2+1);
    s_right = Int(slim/2+slim);

    p_Padding = zeros(θlim*2, slim*2);
    p_Padding[θ_left:θ_right, s_left:s_right] = p;

    return p_Padding;
end

function conical_radon(p, ϕ, μ)

    ratio = 2;
    p = padding(p);
    θlim, slim = size(p);
    θ = LinRange(-2, 2, θlim);
    U = LinRange(-2, 2, θlim);
    V = LinRange(2, -2, slim);
    C = zeros(length(V), length(U));
    interval = 2*ratio / (θlim - 1);

    for Cx = 1:length(U), Cy=1:length(V)

        U_left = 1:Cx;
        y_left = tan(π / 2 + ϕ) * (θ[U_left] .- U[Cx]) .+ V[Cy];
        bit_left = abs.(y_left) .<= 1;
    
        if sum(bit_left)>0
            y_left = y_left[bit_left];
            height_left = ratio .- y_left;
            nearest_row_left = round.(Int64, ((height_left) - mod.(height_left, interval)) / interval) .+ 1;
            U_left = U_left[bit_left];
            for i=1:length(nearest_row_left)
                value_left = p[nearest_row_left[i], U_left[i]];
                r_left = sqrt.((value_left-U[Cx])^2 + (value_left-V[Cy])^2);
               C[Cy, Cx]+= value_left*exp(-μ*r_left);
            end
        end

        U_right = Cx:length(U);
        y_right = tan(π / 2 - ϕ) * (θ[U_right] .- U[Cx]) .+ V[Cy];
        bit_right = abs.(y_right) .<= 1;

        if sum(bit_right)>0
            y_right = y_right[bit_right];
            height_right = ratio .- y_right;           
            nearest_row_right = round.(Int64, ((height_right) - mod.(height_right, interval)) / interval) .+ 1;
            U_right = U_right[bit_right];
            for i=1:length(nearest_row_right)
                value_right = p[nearest_row_right[i], U_right[i]];
                r_right = sqrt.((value_right-U[Cx])^2 + (value_right-V[Cy])^2);
               C[Cy, Cx]+= value_right*exp(-μ*r_right);
            end
        end      
    end

    return C
end