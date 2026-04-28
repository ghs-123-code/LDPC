function [H_sparse] = lift(H,block_size)
I_matrix = eye(block_size, 'uint8');
mtx_M = block_size * size(H, 1);
mtx_N = block_size * size(H, 2);

H_sparse = zeros(mtx_M,mtx_N, 'uint8');
for i = 1 : size(H, 1) 
    for j = 1 : size(H, 2)
        if H(i, j) ~= -1
            H_sparse( (i - 1) * block_size + 1 : i * block_size, (j - 1) * block_size + 1 : j * block_size) = circshift(I_matrix, H(i, j), 2);
        end
    end
end
end
