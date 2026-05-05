clear

addpath('load_H_matrix');
addpath(genpath('5GNR'));
ZC=192;
%% use NR BG 
% bg = Circular_shift_matrix(1,ZC); % 1 for BG1, 2 for BG2
% bg = bg(1:13,1:35);  % code rate 2/3

%% use split BG
bg = [42	85	24	169	145	169	156	31	164	69	16	108	127	37	25	20	58	37	155	45	22	15	134	184	162	190	67	183	172	90	120	154	32	42	132	127	68	126	150	95	77	142	27	84	0	0	-1	-1	-1	-1	-1
174	103	64	132	64	59	164	21	72	148	42	10	109	102	154	167	95	84	126	161	123	12	51	69	185	73	140	55	134	83	177	112	113	113	80	59	27	117	57	163	104	53	129	90	1	0	0	-1	-1	-1	-1
56	-1	157	-1	-1	-1	-1	59	-1	109	-1	-1	36	-1	37	150	-1	-1	-1	176	109	-1	-1	-1	145	187	69	35	60	0	73	123	22	13	74	102	188	153	183	147	139	6	138	45	-1	-1	0	0	-1	-1	-1
-1	160	-1	135	2	56	58	-1	87	-1	84	142	-1	89	-1	-1	23	169	166	-1	-1	38	79	22	-1	-1	-1	-1	-1	-1	63	132	-1	34	78	-1	166	148	182	79	151	8	5	115	0	-1	-1	0	-1	-1	-1
174	103	64	132	-1	-1	164	-1	-1	148	-1	10	-1	-1	-1	167	95	-1	-1	161	-1	-1	51	69	-1	73	140	-1	-1	-1	177	-1	113	113	80	59	27	117	-1	-1	104	53	-1	-1	-1	-1	0	-1	0	-1	-1
-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	118	-1	-1	-1	-1	171	-1	-1	-1	-1	-1	-1	-1	116	45	-1	181	148	-1	-1	30	182	104	107	0	-1
42	85	-1	-1	-1	-1	-1	-1	-1	69	16	-1	-1	-1	-1	20	58	-1	-1	45	-1	15	-1	184	162	-1	-1	-1	-1	90	-1	154	-1	-1	-1	127	68	-1	-1	95	77	142	27	84	-1	0	-1	-1	-1	-1	0];
split_sequence = [0 0 0 0 2 0 1]; % split_sequence(i) with value larger than 0 means row i is split from row split_sequence(i)
bg = split(bg, split_sequence);

%% simulation
bg = flipud(bg); %reverse order scheduling

H = lift(bg,ZC); 
puncture = 0;
[M, N, K, vn_degree, cn_degree, P, H_row_one_absolute_index, H_comlumn_one_relative_index, vn_distribution, cn_distribution] = H_matrix_process(H);

R = K/N;
max_iter = 10;
max_runs = 1e8;
resolution = 1e5;
esno_vec = [23.342];% 22.14
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
