%% Main file for generating all plots

% Data input path
path_fxp16 = "data/log_fxp_16bit_32blocks";
path_fxp8 = "data/log_fxp_8bit_32blocks";

logdata = readtable(path_fxp16 + "/log_data.txt");
logdata_fxp8 = readtable(path_fxp8 + "/log_data.txt");

path_fxp16_p = "data/log_fxp_16bit_prec_32blocks";
path_fxp8_p = "data/log_fxp_8bit_prec_32blocks";

logdata_p = readtable(path_fxp16_p + "/log_data.txt");
logdata_fxp8_p = readtable(path_fxp8_p + "/log_data.txt");

% Noise values 
% noise = [0 10 14 20];
noise = [0 10 20];
noise_full = 0:2:20;

% Different LDPC Iterations
iter = [2 5 10];

% Different Modulations
modul = [16 64 256 512 1024];

%% Generate BER and Eb/N0 plot for each QAM Modulation (FXP 16 and FXP 8 optimal)
for i=1:length(modul)
    EbN0_BER_QAM(logdata, logdata_fxp8, modul(i), iter, noise_full, "optimal");
end

%% Generate BER and Eb/N0 plot for each QAM Modulation (FXP 16 and FXP 8 precision)
for i=1:length(modul)logdata_qam16_fxp = readtable("data/")
    EbN0_BER_QAM(logdata_p, logdata_fxp8_p, modul(i), iter, noise_full, "precision");
end

%% Generate BER and Eb/N0 plot for QAM1024 (0-30dB)
logdata_qam1024 = readtable("data/log_fxp_16bit_QAM1024/log_data.txt");
logdata_qam1024_fxp8 = readtable("data/log_fxp_8bit_QAM1024/log_data.txt");
EbN0_BER_QAM(logdata_qam1024, logdata_qam1024_fxp8, 1024, iter, 0:2:30, "extrange");

%% Generate LDPC execution time and BER for each Noise
for i = 1:length(noise)
    ldpc_time_BER(noise(i), iter, path_fxp16);
end

%% Generate Demodulator FXP16 and FXP8 execution time (optimal)
for i = 1:length(noise)
    demod_time_fxp16_fxp8(noise(i), 2, path_fxp16, path_fxp8, "optimal");
end

%% Generate Demodulator FXP16 and FXP8 execution time (precision)
for i = 1:length(noise)
    demod_time_fxp16_fxp8(noise(i), 2, path_fxp16_p, path_fxp8_p, "precision");
end

%% Generate Demodulator FXP16 and FXP8 execution time (optimal and precision)
for i = 1:length(noise)
    demod_time_fxp16_fxp8_precision(noise(i), 2, path_fxp16, path_fxp8, path_fxp16_p, path_fxp8_p);
end

%% Generate Demodulator FXP16 Approximate BER (1 distance)
logdata_qam16_apprx_1d = readtable("data/log_fxp_approx_1d/log_data.txt");
EbN0_BER_QAM(logdata, logdata_qam16_apprx_1d, 16, iter, noise_full, "approx-1d");

%% Generate Demodulator FXP16 Approximate BER (2 distances)
logdata_qam16_apprx_2d = readtable("data/log_fxp_approx_2d/log_data.txt");
EbN0_BER_QAM(logdata, logdata_qam16_apprx_2d, 16, iter, noise_full, "approx-2d");

%% Generate Demodulator FXP16 Approximate BER (2 distances)
logdata_qam16_apprx_1d = readtable("data/log_fxp_approx_1d/log_data.txt");
logdata_qam16_apprx_2d = readtable("data/log_fxp_approx_2d/log_data.txt");
EbN0_BER_QAM(logdata_qam16_apprx_1d, logdata_qam16_apprx_2d, 16, iter, noise_full, "approx");

%% Generate Demodulator FXP16 Approximate BER (bad)
logdata_qam16_apprx_bad = readtable("data/log_fxp_approx_bad/log_data.txt");
EbN0_BER_QAM(logdata, logdata_qam16_apprx_bad, 16, iter, noise_full, "approx-bad");

%% Generate Demodulator FXP16 Approximate BER (full)
logdata_qam16_apprx_full = readtable("data/log_fxp_approx_full/log_data.txt");
EbN0_BER_QAM(logdata, logdata_qam16_apprx_full, 16, iter, noise_full, "approx-full");