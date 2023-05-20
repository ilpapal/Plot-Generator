% Function to plot all BER values for one modulation
function EbN0_BER_QAM(logdata, logdata_fxp8, modul, iter, EbN0)
    % Load colors from colors.m
    run("colors.m");
    
    % Array with different line styles
    lines = ["--^" "-.^" ":^"];

    % Calculate theoretical BER values for given modulation and AWGN Channel
    EbN0_fit = linspace(EbN0(1), EbN0(end));
    BER_theor = berawgn(EbN0_fit, 'qam', modul);

    % Fit BER data
    % BER_fit(BER_theor, EbN0, coral, "--");

    % Add markers for calculated datapoints
    figure;
    semilogy(EbN0_fit, BER_theor + eps, ...
        "-", "MarkerSize", 7, "LineWidth", 1,...
        "MarkerFaceColor", crimson, "Color", crimson,...
        "DisplayName", "MATLAB Reference");
    hold on;

    % Import BER FLP implementation reference 
%     refdata = readtable("data/log_flp_BER_ldpc10/log_data.txt");
    refdata = readtable("data/log_flp_sf8/log_data.txt");

    % Extract reference BER for specific Modulation and 10 LDPC iterations
%     idx = find(refdata.Modulation == modul & refdata.LDPC_Iter == 10);
    idx = find(refdata.Modulation == modul & refdata.LDPC_Iter == 50);
        
    % Create array with EbN0dB noise and BER value
    y(:,1) = refdata.EbN0dB(idx);
    y(:,2) = refdata.BER(idx);

    % Add markers for calculated datapoints
    semilogy(y(:,1), y(:,2) + eps, ...
        "-*", "MarkerSize", 7, "LineWidth", 1,...
        "MarkerFaceColor", dark_red, "Color", dark_red,...
        "DisplayName", "FLP 50 Iter (Sf=8)");
    hold on;

    % For loop
    for i=1:length(iter)
        % Extract data from table for specific Modulation and LDPC iterations
        idx = find(logdata.Modulation == modul & logdata.LDPC_Iter == iter(i));

        % Create array with EbN0dB noise and BER value
        y(:,1) = logdata.EbN0dB(idx);
        y(:,2) = logdata.BER(idx);

        % Plot BER relative to Eb/N0
        semilogy(y(:,1), y(:,2) + eps, ...
            lines(i), "MarkerSize", 6, "LineWidth", 1,...
            "MarkerFaceColor", navy_blue, "Color", navy_blue,...
            "DisplayName", "FXP S2.14 " + iter(i) + " Iter");
        hold on;
    end

    for i=1:length(iter)
        % FX8
        idx_2 = find(logdata_fxp8.Modulation == modul & logdata_fxp8.LDPC_Iter == iter(i));
        
        % FXP8
        % Create array with EbN0dB noise and BER value
        y(:,1) = logdata_fxp8.EbN0dB(idx_2);
        y(:,2) = logdata_fxp8.BER(idx_2);

        % Plot BER relative to Eb/N0
        semilogy(y(:,1), y(:,2) + eps, ...
            lines(i), "MarkerSize", 6, "LineWidth", 1,...
            "MarkerFaceColor", steel_blue, "Color", steel_blue,...
            "DisplayName", "FXP S2.6 " + iter(i) + " Iter");
        hold on;
    end

    % For y axis values range
    ylim([10^(-4) 1]);

    % Add title and labels to plot
    title("Demodulator FXP Implementation - QAM" + modul);
    grid on;
    xlabel("Eb/N0 [dB]");
    ylabel("Bit Error Rate (BER)");
    legend("show", "Location", "southwest");
    
    % Save plot
    saveas(gcf, "plots/EbN0_BER_QAM" + modul, "epsc");
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