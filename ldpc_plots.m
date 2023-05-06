% Function to generate all plots
% noise = [0 5 10 14 20];
noise = 20;

% Create plot for each noise value
for i = 1:length(noise)
%     ldpc_time_llr_plot(noise(i), 2, 5, 10, "log_demod_fxp_base_16bit_sf8");
%     ldpc_time_llr_plot(noise(i), 2, 5, 10, "log_16bit_jetson_1");
    ldpc_time_llr_plot(noise(i), 2, 5, 10, "data/log_fxp_rate23_a025_latest");
end