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

    p = padding(p);
    θlim, slim = size(p);
    θ = LinRange(-2, 2, θlim);
    U = LinRange(-2, 2, θlim);
    V = LinRange(2, -2, slim);
    C = zeros(length(V), length(U));
    interval = 2/(θlim-1);

    for Cx = 1:length(U), Cy=1:length(V)

        for column = 1:θlim
            y_left = tan(π/2+ϕ)*(θ[column]-U[Cx])+V[Cy];
            y_right = tan(π/2-ϕ)*(θ[column]-U[Cx])+V[Cy];

            if -1 ≤ y_left ≤ 1 
                height = 1-y_left;
                nearest_row = round(Int64, ((height)-mod(height, interval))/interval)+1;
                r = sqrt((U[Cx]-p[nearest_row, column])^2+(V[Cy]-p[nearest_row, column])^2);
                C[Cy, Cx]+=p[nearest_row, column]*exp(-μ*r);
            end

            if -1 ≤ y_right ≤ 1
                height = 1-y_right;
                nearest_row = round(Int64, ((height)-mod(height, interval))/interval)+1;
                r = sqrt((U[Cx]-p[nearest_row, column])^2+(V[Cy]-p[nearest_row, column])^2);
                C[Cy, Cx]+=p[nearest_row, column]*exp(-μ*r);
            end
        
        end
    end

    return C
end