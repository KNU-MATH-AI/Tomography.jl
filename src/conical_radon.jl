using Tomography

function conical_radon(p, ϕ)

    μ = 1;
    θlim, slim = size(p);
    θ = LinRange(-1, 1, θlim);
    U = LinRange(-1, 1, θlim);
    V = LinRange(-1, -2, slim);
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

p = reverse(rand(200,200)^0, dims=2);

C = conical_radon(p, π/4);
using Plots; heatmap(reverse(C, dims=1))