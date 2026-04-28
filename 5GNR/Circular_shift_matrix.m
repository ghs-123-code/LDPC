function [matrix] = Circular_shift_matrix(BGtype, blocksize)

block_size = blocksize;
Zc1 = [2 4 8 16 32 64 128 256];
Zc2 = [3 6 12 24 48 96 192 384];
Zc3 = [5 10 20 40 80 160 320];
Zc4 = [7 14 28 56 112 224];
Zc5 = [9 18 36 72 144 288];
Zc6 = [11 22 44 88 176 352];
Zc7 = [13 26 52 104 208];
Zc8 = [15 30 60 120 240]; 
    if ismember(block_size,Zc1)
        file = sprintf('%s%d%s%d%s','NR_',BGtype,'_0_',blocksize,'.txt'); 
        matrix = load(sprintf('%s%s','base_matrices/',file)); 
    elseif ismember(block_size,Zc2)
        file = sprintf('%s%d%s%d%s','NR_',BGtype,'_1_',blocksize,'.txt'); 
        matrix = load(sprintf('%s%s','base_matrices/',file));
    elseif ismember(block_size,Zc3)
        file = sprintf('%s%d%s%d%s','NR_',BGtype,'_2_',blocksize,'.txt'); 
        matrix = load(sprintf('%s%s','base_matrices/',file));
    elseif ismember(block_size,Zc4)
        file = sprintf('%s%d%s%d%s','NR_',BGtype,'_3_',blocksize,'.txt'); 
        matrix = load(sprintf('%s%s','base_matrices/',file));
    elseif ismember(block_size,Zc5)
        file = sprintf('%s%d%s%d%s','NR_',BGtype,'_4_',blocksize,'.txt'); 
        matrix = load(sprintf('%s%s','base_matrices/',file));
    elseif ismember(block_size,Zc6)
        file = sprintf('%s%d%s%d%s','NR_',BGtype,'_5_',blocksize,'.txt'); 
        matrix = load(sprintf('%s%s','base_matrices/',file));
    elseif ismember(block_size,Zc7)
        file = sprintf('%s%d%s%d%s','NR_',BGtype,'_6_',blocksize,'.txt'); 
        matrix = load(sprintf('%s%s','base_matrices/',file));
    elseif ismember(block_size,Zc8)
        file = sprintf('%s%d%s%d%s','NR_',BGtype,'_7_',blocksize,'.txt'); 
        matrix = load(sprintf('%s%s','base_matrices/',file));
    end
end

