function [num_block_err, num_bit_err, num_iter, num_runs] = simulation(esno_vec, conste_name, P, H_row_one_absolute_index, H_comlumn_one_relative_index, N, M, K, vn_degree,...
cn_degree, vn_distribution, cn_distribution, max_iter, max_runs, resolution, max_err, puncture, ZC)
N_tx = N - puncture * ZC;
num_runs = zeros(length(esno_vec), 1);
num_block_err = zeros(length(esno_vec), 1);
num_bit_err = zeros(length(esno_vec), 1);
num_iter = zeros(length(esno_vec), 1);
[constellation, rho_inv, base_vec, demod_indices, demod_indices0, is2D, m, num_conste_points] = get_constellation(conste_name, N_tx);
interleaver_sub=zeros(1,m);
for i = 1:m/2
    interleaver_sub(2*i-1)=i;
    interleaver_sub(2*i)=i+m/2;
end

tic
% profile on
for i_run = 1 : max_runs
    if  mod(i_run, max_runs/resolution) == 1
        disp(' ')
        disp([conste_name ' Simualtion Running = ' num2str(i_run)])
        disp(['N = ' num2str(N_tx) ', K = ' num2str(K) ', Max Iteration Number = ' num2str(max_iter) '. ' 'H density = ' num2str(100 * sum(vn_degree)/M/N) '%.']);
        disp(' ');
        disp('VN Degree Distribution: ');
        disp(vn_distribution);
        disp(' ');
        disp('CN Degree Distribution: ');
        disp(cn_distribution);
        disp(' ');
        disp('current BLER');
        disp(num2str([esno_vec' num_block_err./num_runs]));
        disp('current BER');
        disp(num2str([esno_vec' num_bit_err./num_runs/K]));
        disp('Average Iteration Numbers')
        disp(num2str([esno_vec' num_iter./num_runs]));
    end    
    u = round(rand(K, 1));
    parity_check_bits = mod(P * u, 2);
    x = [u; parity_check_bits];
    x = x(ZC*puncture+1:end);
    inter_A = reshape(1:N_tx,N_tx/m,m)';
    inter_A = inter_A([1:2:m 2:2:m],:);
    inter_A = inter_A(:);
    x = x(inter_A);
    symbol = modulation(constellation, m, rho_inv, x, base_vec, N_tx);
    n = randn(N_tx/m, 1) + randn(N_tx/m, 1) * 1j * is2D;
    n = n/sqrt(2);
    for i_esno = 1 : length(esno_vec)
        if num_block_err(i_esno) >= max_err
            continue;
        end
        num_runs(i_esno) = num_runs(i_esno) + 1;
        sigma = 10^(-esno_vec(i_esno)/20);
        y = symbol + sigma * n;
        llr = demodulation(y, constellation, m, num_conste_points, demod_indices, demod_indices0, sigma, N_tx);
        B = reshape(llr,m,N_tx/m);
        B = B(interleaver_sub,:)';
        llr = B(:);
        llr=[zeros(ZC*puncture,1);llr];

        [x_hat, iter_this_time] = Layered_NMS_decoder(llr, H_row_one_absolute_index, H_comlumn_one_relative_index, N, M, vn_degree, cn_degree, max_iter);
        
        num_iter(i_esno) = num_iter(i_esno) + iter_this_time;
        if any(x_hat(1:K) ~= u)
            num_block_err(i_esno) = num_block_err(i_esno) + 1;
            num_bit_err(i_esno) = num_bit_err(i_esno) + sum(u ~= x_hat(1 : K));
        end
    end
    if all(num_block_err == max_err)
        break;
    end
end
% profile viewer
toc