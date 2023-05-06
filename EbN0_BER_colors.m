path = "log_demod_fxp_base_16bit_sf8";
modul = 64;

% Different LDPC Iterations
iter = [2 5 10];

% Load colors from colors.m
run("colors.m");

% Number of different modulations
M = 5;

% Import data from log_data.txt file
logdata = readtable(path + '/log_data.txt');

figure;

ber_ebn0(logdata, iter, 16, purple_palette);
ber_ebn0(logdata, iter, 64, blue_palette);
ber_ebn0(logdata, iter, 256, green_palette);
ber_ebn0(logdata, iter, 512, red_palette);
ber_ebn0(logdata, iter, 1024, yellow_palette);

title("Demodulator FXP S2.14 NEON Implementation");
grid on;
xlabel("Eb/N0 (dB)");
ylabel("Bit Error Rate (BER)");
% legend("show", "Location", "eastoutside", "FontSize", 7);
legend("show", "Location", "southoutside", "NumColumns", M, "FontSize", 8);

% Save plot
set(gcf, "Position", [2000 1500 950 950/1.618]);
saveas(gcf, "plots/EbN0_BER", "epsc");
% save("data");

% Function to plot all BER values for one modulation
function ber_ebn0(logdata, iter, modul, color_arr)
    % For loop
    for i=1:length(iter)
        % Extract data from table for specific Modulation and LDPC iterations
        idx = find(logdata.Modulation == modul & logdata.LDPC_Iter == iter(i));
        
        % Create array with EbN0dB noise and BER value
        y(:,1) = logdata.EbN0dB(idx);
        y(:,2) = logdata.BER(idx);
        
        % Plot BER relative to noise level
        semilogy(y(:,1), y(:,2) + 0.0001, ...
            "-^", "MarkerSize", 7,...
            "MarkerFaceColor", color_arr(i,:), "Color", color_arr(i,:),...
            "DisplayName", "QAM" + modul + ", " + iter(i) + " Iter");
        hold on;
        axis padded;
    end
end