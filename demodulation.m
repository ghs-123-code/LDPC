function llr = demodulation(y, constellation, m, M, demod_indices, demod_indices0, sigma, N)
%This function is much faster than the system-function 'qamdemod(y, M, 'OutputType', 'llr', NoiseVariance', sigma^2)'.

p0 = zeros(N, 1);
p1 = zeros(N, 1);
for i_y = 1 : length(y)
    index_y = m * (i_y - 1);
    p_ylx = abs(y(i_y) - constellation).^2/2/sigma^2;
    for i_m = 1 : m
        index_m = M/2 * (i_m - 1);
        i_c = 1 : M/2;
        p1(index_y + i_m) = min(p_ylx(demod_indices(index_m + i_c)));
        p0(index_y + i_m) = min(p_ylx(demod_indices0(index_m + i_c)));

    end
end
llr = p1-p0;
llr(llr > 40) = 40;
llr(llr < -40) = -40;
end