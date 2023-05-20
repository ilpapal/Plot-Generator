%% Main file for generating all plots

% Data input path
% path_fxp16 = "data/log_demod_fxp_16bit_project";
path_fxp16 = "data/log_fxp_16bit";
path_fxp8 = "data/log_fxp_8bit";
logdata = readtable(path_fxp16 + "/log_data.txt");
logdata_fxp8 = readtable(path_fxp8 + "/log_data.txt");

% Noise values 
noise = [0 5 10 14 20];
noise_full = 0:2:20;

% Different LDPC Iterations
iter = [2 5 10];

% Different Modulations
modul = [16 64 256 512 1024];

%% Generate BER and Eb/N0 plot for each QAM Modulation
for i=1:length(modul)
%     EbN0_BER_QAM(logdata, logdata_fxp8, modul(i), iter, noise);
    EbN0_BER_QAM(logdata, logdata_fxp8, modul(i), iter, noise_full);
end

%% Generate LDPC execution time and BER for each Noise
for i = 1:length(noise)
    ldpc_time_BER(noise(i), iter, path_fxp16);
end

%% Generate Demodulator execution time with LLR Mean Relative Error
for i = 1:length(noise)
    demod_time_llr_plot(noise(i), 2, path_fxp16);
end

%% Generate Demodulator FXP16 and FXP8 execution time
for i = 1:length(noise)
    demod_time_fxp16_fxp8(noise(i), 2, path_fxp16, path_fxp8);
end