function s = modulation(constellation, m, rho_inv, x, base_vec, N)
%Fast modulation.
numbers = x .* base_vec;
s = constellation(rho_inv(1 + sum(reshape(numbers, m, N/m))));
end
        
        