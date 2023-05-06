% Function to generate all plots
% noise = [0 5 10 14 20];
noise = 20;

% Create plot for each noise value
for i = 1:length(noise)
%     demod_time_llr_plot(noise(i), 2, "log_demod_fxp_base_16bit_sf8");
%     demod_time_llr_plot(noise(i), 2, "log_16bit_jetson_1");
    demod_time_llr_plot(noise(i), 2, "data/log_fxp_rate23_a025_latest");
end