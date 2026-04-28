function [x_hat, iter_this_time] = Layered_NMS_decoder(llr, H_row_one_absolute_index, H_comlumn_one_relative_index, N, M, vn_degree, cn_degree, max_iter)
VN_array = zeros(max(vn_degree), N);
CN_tanh_tmp = zeros(max(cn_degree), 1);%CN temporary memory.
iter_this_time = max_iter;

for t = 1 : max_iter
    for c = 1 : M
 
    min1 = inf;     
    min2 = inf;      
    min_index = 1;   
    S_all = 1;
    
      for c_neighbor = 1 : cn_degree(c)
      
        Lji = sum(VN_array(:, H_row_one_absolute_index(c, c_neighbor))) + ...
              llr(H_row_one_absolute_index(c, c_neighbor)) - ...
              VN_array(H_comlumn_one_relative_index(c, c_neighbor), H_row_one_absolute_index(c, c_neighbor));
        

        CN_tanh_tmp(c_neighbor) = Lji;
        

        abs_Lji = abs(Lji);
        s = sign(Lji);
            if s == 0, s = 1; end
            S_all = S_all * s;
        if abs_Lji < min1
            min2 = min1;
            min1 = abs_Lji;
            min_index = c_neighbor;
        elseif abs_Lji < min2
            min2 = abs_Lji;
        end
      end
    

    for c_neighbor = 1 : cn_degree(c)

                s_self = sign(CN_tanh_tmp(c_neighbor));
            if s_self == 0, s_self = 1; end
            sign_product = S_all * s_self;

        if c_neighbor == min_index

            magnitude = min2;
        else

            magnitude = min1;
        end
        


        Lij = 0.75*sign_product * magnitude;
        

        VN_array(H_comlumn_one_relative_index(c, c_neighbor), H_row_one_absolute_index(c, c_neighbor)) = Lij;
    end
    end
    x_hat = (sum(VN_array)' + llr) < 0;%Belief propagation Decision.
    parity_check = zeros(M, 1);
    for m = 1 : M
        for k = 1 : 1 : cn_degree(m)
            parity_check(m) = parity_check(m) + x_hat(H_row_one_absolute_index(m, k));
        end
    end
    if ~sum(mod(parity_check, 2))%early stop, to see whether Hx = 0.
        iter_this_time = t;
        break;
    end
end