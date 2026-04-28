clear

addpath('load_H_matrix');
addpath(genpath('5GNR'));
ZC=384;
bg = Circular_shift_matrix(1,ZC); % 1 for BG1, 2 for BG2
bg = bg(1:13,1:35);  % code rate 2/3
bg = flipud(bg); %reverse order scheduling

H = lift(bg,ZC); 
puncture = 2;
[M, N, K, vn_degree, cn_degree, P, H_row_one_absolute_index, H_comlumn_one_relative_index, vn_distribution, cn_distribution] = H_matrix_process(H);

R = K/N;
max_iter = 10;
max_runs = 1e8;
resolution = 1e5;
esno_vec = [18.5 18.75];% 22.14
conste_name = '256QAM';
max_err = 100;
%Supported constellation types:
% QPSK, 16QAM, 256QAM,  All in Gray Lableing.
%Naive Modulation, e.g., x1,x2,...,xm are mapped into one symbol and then transmitted
%BICM-style demodulation, i.e., independent bit level, one received symbol ¡û¡ú m LLRs
[num_block_err, num_bit_err, num_iter, num_runs] = simulation(esno_vec, conste_name, P, H_row_one_absolute_index, H_comlumn_one_relative_index, N, M, K, vn_degree, cn_degree, ...
    vn_distribution, cn_distribution, max_iter, max_runs, resolution, max_err, puncture, ZC);
disp('BLER simulation is finished.')
bler = sum(num_block_err, 2)./sum(num_runs, 2);
ber = sum(num_bit_err, 2)./sum(num_runs, 2)/K;
ave_iter = sum(num_iter, 2)./sum(num_runs, 2);
