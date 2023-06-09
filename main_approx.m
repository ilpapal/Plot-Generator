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
