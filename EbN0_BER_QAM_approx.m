% Function to plot all BER values for one modulation
function EbN0_BER_QAM_approx(logdata, logdata_fxp8, modul, iter, EbN0, impl_name)
    % Load colors from colors.m
    run("colors.m");
    
    % Array with different line styles
%     lines = ["--^" "-.^" ":^"];
    lines_1 = ["--square" "-.square" ":square"];
    lines_2 = ["--^" "-.^" ":^"];

    % Calculate theoretical BER values for given modulation and AWGN Channel
    EbN0_fit = linspace(EbN0(1), EbN0(end));
    BER_theor = berawgn(EbN0_fit, 'qam', modul);

    % Fit BER data
    % BER_fit(BER_theor, EbN0, coral, "--");

    % Add markers for calculated datapoints
    figure;
    semilogy(EbN0_fit, BER_theor + eps, ...
        "-", "MarkerSize", 7, ...
        "MarkerFaceColor", sea_green, "Color", sea_green,...
        "DisplayName", "Theoretical Reference");
    hold on;

    % Import BER FLP implementation reference 
    refdata = readtable("data/approx/log_flp_ldpc_qam16/log_data.txt");
%     refdata = readtable("data/log_flp_sf8_32blocks/log_data.txt");
%     refdata = readtable("data/log_flp_qam16_nofec/log_data.txt");

    % Extract reference BER for specific Modulation and 10 LDPC iterations
    idx = find(refdata.Modulation == modul & refdata.LDPC_Iter == 30);
        
    % Create array with EbN0dB noise and BER value
    y_flp(:,1) = refdata.EbN0dB(idx);
    y_flp(:,2) = refdata.BER(idx);

    % Add markers for calculated datapoints
    semilogy(y_flp(:,1), y_flp(:,2) + eps, ...
        "-*", "MarkerSize", 7, ...
        "MarkerFaceColor", dark_red, "Color", dark_red,...
        "DisplayName", "FLP 50 Iter");
    hold on;

    % For loop
%     iter = [2 5 10];
    for i=1:length(iter)
        % Extract data from table for specific Modulation and LDPC iterations
        idx = find(logdata.Modulation == modul & logdata.LDPC_Iter == iter(i));

        % Create array with EbN0dB noise and BER value
        y_fxp16(:,1) = logdata.EbN0dB(idx);
        y_fxp16(:,2) = logdata.BER(idx);

        % Plot BER relative to Eb/N0
        semilogy(y_fxp16(:,1), y_fxp16(:,2) + eps, ...
            lines_1(i), "MarkerSize", 6, ...
            "Color", navy_blue,...
            "DisplayName", "FXP S2.14 " + iter(i) + " Iter");
%             "DisplayName", "FXP S2.14 APX1 " + iter(i) + " Iter");
        hold on;
    end

    iter = [2 5 10];
    for i=1:length(iter)
        % FX8
        idx_2 = find(logdata_fxp8.Modulation == modul & logdata_fxp8.LDPC_Iter == iter(i));
        
        % FXP8
        % Create array with EbN0dB noise and BER value
        y_fxp8(:,1) = logdata_fxp8.EbN0dB(idx_2);
        y_fxp8(:,2) = logdata_fxp8.BER(idx_2);

        % Plot BER relative to Eb/N0
        semilogy(y_fxp8(:,1), y_fxp8(:,2) + eps, ...
            lines_2(i), "MarkerSize", 6,...
            "Color", steel_blue,...
            "DisplayName", "FXP S2.14 APX2 " + iter(i) + " Iter");
%             "DisplayName", "FXP S2.6 " + iter(i) + " Iter");
        hold on;
    end

    % For y axis values range
    ylim([10^(-5) 1]);

    % Add title and labels to plot
    title("QAM" + modul + ...
            " (32 Blocks, N=64800, Rate=1/2, " + impl_name + ")");
    grid on;
    xlabel("Eb/N0 [dB]");
    ylabel("Bit Error Rate (BER)");
%     legend("show", "Location", "southwest");
    legend("show", "Location", "northeast");
%     legend("show", "Location", "southeast");
    
    % Save plot
    % gcf
    saveas(gcf, "plots/EbN0_BER_" + impl_name + "_QAM" + modul, "epsc");
end


%% Function to fit BER values for more Eb/N0 points
function BER_fit(BER_inp, EbN0, color_value, line)
    % Array for fit EbN0 values 
    EbN0_fit = linspace(0, 20);

    % Use polyfit for each BER data
    BER_theor_fit = berfit(EbN0, BER_inp, EbN0_fit);

    % Plot theoretical BER fit relative to Eb/N0
    semilogy(EbN0_fit, BER_theor_fit, line,...
        "MarkerFaceColor", color_value, "Color", color_value,...
        "DisplayName", "Theoretical BER");
    hold on;
end