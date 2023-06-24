iter = [2 5 10];

noise_full = 0:2:20;

%% Generate Demodulator FXP16 Approximate BER (2 distances)
% log_fxp_nofec_base_qam16 = readtable("data/approx/log_fxp_nofec_base_qam16/log_data.txt");
log_fxp_nofec_base_qam16 = readtable("data/approx/log_foobar/log_data.txt");
log_fxp_nofec_approx_qam16 = readtable("data/approx/log_fxp_nofec_approx_qam16/log_data.txt");

% log_fxp_nofec_base8_qam16 = readtable("data/approx/log_fxp_nofec_base8_qam16/log_data.txt");
% log_fxp_nofec_approx8_qam16 = readtable("data/approx/log_fxp_nofec_base8_qam16/log_data.txt");

EbN0_BER_QAM_approx_nofec( ...
    log_fxp_nofec_base_qam16, log_fxp_nofec_approx_qam16, ...
    16, 0, noise_full, "approx");

%% Generate Demodulator FXP16 execution time (original and approximate)
path_fxp16_orig = "data/approx/log_fxp_nofec_base_qam16";
path_fxp16_approx = "data/approx/log_fxp_nofec_approx_qam16";
demod_time_fxp16_approx(10, 0, path_fxp16_orig, path_fxp16_approx);

%% Generate Demodulator FXP16 execution time (original and approximate)
path_fxp16_orig = "data/approx/log_fxp_nofec_base32_qam16";
path_fxp16_approx = "data/approx/log_fxp_nofec_base32_qam16";
demod_time_fxp16_approx(10, 0, path_fxp16_orig, path_fxp16_approx);


%% Generate Demodulator FXP16 execution time (original and approximate)
path_fxp16_orig = "data/approx/log_fxp_nofec_base_qam16";
path_fxp16_approx = "data/approx/log_fxp_nofec_approx_qam16";
path_fxp32_orig = "data/approx/log_fxp_nofec_base_qam16";
path_fxp32_approx = "data/approx/log_fxp_nofec_approx_qam16";

demod_time_fxp16_fxp32_approx(10, 0, ...
    path_fxp16_orig, path_fxp16_approx, path_fxp16_orig, path_fxp16_approx);




%% ****** QAM 64 ******
%% Generate Demodulator FXP16 Approximate BER NO FEC
log_fxp_nofec_base16_qam64 = readtable("data/approx/log_fxp_nofec_base_qam64/log_data.txt");
log_fxp_nofec_base32_qam64 = readtable("data/approx/log_fxp_nofec_base32_qam64/log_data.txt");

log_fxp_nofec_approx16_qam64 = readtable("data/approx/QAM64/log_fxp16_nofec_approx_mul16_qam64/log_data.txt");
log_fxp_nofec_approx32_qam64 = readtable("data/approx/QAM64/log_fxp16_nofec_approx_mul32_qam64/log_data.txt");

log_fxp8_nofec_base16_qam64 = readtable("data/approx/QAM64/log_fxp8_nofec_base_mul16_qam64/log_data.txt");
log_fxp8_nofec_base32_qam64 = readtable("data/approx/QAM64/log_fxp8_nofec_base_mul32_qam64/log_data.txt");

log_fxp8_nofec_approx16_qam64 = readtable("data/approx/QAM64/log_fxp8_nofec_approx_mul16_qam64/log_data.txt");
log_fxp8_nofec_approx32_qam64 = readtable("data/approx/QAM64/log_fxp8_nofec_approx_mul32_qam64/log_data.txt");

% 16-Bit
EbN0_BER_QAM_approx_nofec_mul16_mul32( ...
    log_fxp_nofec_base16_qam64, log_fxp_nofec_approx16_qam64, ...
    log_fxp_nofec_base32_qam64, log_fxp_nofec_approx32_qam64, ...
    64, noise_full, "approx", 16);

%% 8-Bit
EbN0_BER_QAM_approx_nofec_mul16_mul32( ...
    log_fxp_nofec_base16_qam64, log_fxp8_nofec_approx16_qam64, ...
    log_fxp_nofec_base32_qam64, log_fxp8_nofec_approx32_qam64, ...
    64, noise_full, "approx", 8);


%% Generate Demodulator FXP16 Approximate BER LDPC
log_fxp_ldpc_base16_qam64 = readtable("data/approx/QAM64/log_fxp16_ldpc_base_mul16_qam64/log_data.txt");
log_fxp_ldpc_base32_qam64 = readtable("data/approx/QAM64/log_fxp16_ldpc_base_mul32_qam64/log_data.txt");

log_fxp_ldpc_approx16_qam64 = readtable("data/approx/QAM64/log_fxp16_ldpc_approx_mul16_qam64/log_data.txt");
log_fxp_ldpc_approx32_qam64 = readtable("data/approx/QAM64/log_fxp16_ldpc_approx_mul32_qam64/log_data.txt");

log_fxp8_ldpc_base16_qam64 = readtable("data/approx/QAM64/log_fxp8_ldpc_base_mul16_qam64/log_data.txt");
log_fxp8_ldpc_base32_qam64 = readtable("data/approx/QAM64/log_fxp8_ldpc_base_mul32_qam64/log_data.txt");

log_fxp8_ldpc_approx16_qam64 = readtable("data/approx/QAM64/log_fxp8_ldpc_approx_mul16_qam64/log_data.txt");
log_fxp8_ldpc_approx32_qam64 = readtable("data/approx/QAM64/log_fxp8_ldpc_approx_mul32_qam64/log_data.txt");

% 16-Bit
EbN0_BER_QAM_approx_ldpc( ...
    log_fxp_ldpc_base16_qam64, log_fxp_ldpc_approx16_qam64, ...
    64, noise_full, iter, "approx", 16, 16);

% 16-Bit
EbN0_BER_QAM_approx_ldpc( ...
    log_fxp_ldpc_base32_qam64, log_fxp_ldpc_approx32_qam64, ...
    64, noise_full, iter, "approx", 16, 32);

%% 8-Bit
EbN0_BER_QAM_approx_ldpc( ...
    log_fxp8_ldpc_base16_qam64, log_fxp8_ldpc_approx16_qam64, ...
    64, noise_full, iter, "approx", 8, 16);

EbN0_BER_QAM_approx_ldpc( ...
    log_fxp8_ldpc_base32_qam64, log_fxp8_ldpc_approx32_qam64, ...
    64, noise_full, iter, "approx", 8, 32);


%% rx exec time
rx_time_nofec( ...
    log_fxp_nofec_base16_qam64, log_fxp_nofec_approx16_qam64, ...
    log_fxp_nofec_base32_qam64, log_fxp_nofec_approx32_qam64, ...
    log_fxp8_nofec_base16_qam64, log_fxp8_nofec_approx16_qam64, ...
    log_fxp8_nofec_base32_qam64, log_fxp8_nofec_approx32_qam64);

%% rx exec time LDPC
for i=1:length(iter)
    rx_time_ldpc( ...
        log_fxp_ldpc_base16_qam64, log_fxp_ldpc_approx16_qam64, ...
        log_fxp_ldpc_base32_qam64, log_fxp_ldpc_approx32_qam64, ...
        log_fxp8_ldpc_base16_qam64, log_fxp8_ldpc_approx16_qam64, ...
        log_fxp8_ldpc_base32_qam64, log_fxp8_ldpc_approx32_qam64, ...
        iter(i));
end


%% Demod exec time
demod_time( ...
    log_fxp_nofec_base16_qam64, log_fxp_nofec_approx16_qam64, ...
    log_fxp_nofec_base32_qam64, log_fxp_nofec_approx32_qam64, ...
    log_fxp8_nofec_base16_qam64, log_fxp8_nofec_approx16_qam64, ...
    log_fxp8_nofec_base32_qam64, log_fxp8_nofec_approx32_qam64);