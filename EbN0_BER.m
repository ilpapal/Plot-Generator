% Data input path
% path = "data/log_fxp_rate23_a025_latest";
path = "data/log_demod_fxp_16bit_project";

% Different LDPC Iterations
iter = [2 5 10];

% Load colors from colors.m
run("colors.m");

% Array with different line styles
lines = ["-*" "--*" "-.*"];

% Number of different modulations
M = 5;

% Import data from log_data.txt file
logdata = readtable(path + "/log_data.txt");

% Import BER flp implementation reference 
refdata = readtable("data/log_flp_BER_ldpc10/log_data.txt");

figure;

% Plot BER for each Modulation type
ber_ebn0(logdata, refdata, iter, 16, navy_blue, lines, dark_red);
ber_ebn0(logdata, refdata, iter, 64, royal_blue, lines, maroon);
ber_ebn0(logdata, refdata, iter, 256, steel_blue, lines, crimson);
ber_ebn0(logdata, refdata, iter, 512, sky_blue, lines, tomato);
ber_ebn0(logdata, refdata, iter, 1024, cornflower_blue, lines, coral);

title("Demodulator FXP S2.14 NEON Implementation");
grid on;
xlabel("Eb/N0 [dB]");
ylabel("Bit Error Rate (BER)");
% legend("show", "Location", "eastoutside", "FontSize", 7);
legend("show", "Location", "southoutside", "NumColumns", M, "FontSize", 8);

% Save plot
set(gcf, "Position", [2000 1500 950 950/1.618]);
saveas(gcf, "plots/EbN0_BER", "epsc");

% Function to plot all BER values for one modulation
function ber_ebn0(logdata, refdata, iter, modul, color_name, lines, color_name_ref)
    % Extract reference BER for specific Modulation and 10 LDPC iterations
    idx = find(refdata.Modulation == modul & refdata.LDPC_Iter == 10);
        
    % Create array with EbN0dB noise and BER value
    y(:,1) = refdata.EbN0dB(idx);
    y(:,2) = refdata.BER(idx);

    % Plot reference BER model
    semilogy(y(:,1), y(:,2) + 0.000001, ...
        "--^", "MarkerSize", 7,...
        "MarkerFaceColor", color_name_ref, "Color", color_name_ref,...
        "DisplayName", "QAM" + modul + ", " + iter(1) + " Iter FLP");
    hold on;

    % For loop
    for i=1:length(iter)
        % Extract data from table for specific Modulation and LDPC iterations
        idx = find(logdata.Modulation == modul & logdata.LDPC_Iter == iter(i));
        
        % Create array with EbN0dB noise and BER value
        y(:,1) = logdata.EbN0dB(idx);
        y(:,2) = logdata.BER(idx);
        
        % Plot BER relative to noise level
        semilogy(y(:,1), y(:,2) + 0.000001, ...
            lines(i), "MarkerSize", 7,...
            "MarkerFaceColor", color_name, "Color", color_name,...
            "DisplayName", "QAM" + modul + ", " + iter(i) + " Iter FXP");
        hold on;

        % For y axis values range
        ylim("padded");
    end
end