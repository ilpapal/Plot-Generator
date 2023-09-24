% Plot results together for a given QAM Modulation
function EbN0_BER_QAM_combined( ...
    logdata_fxp_nofec_base32, logdata_fxp_nofec_approx32,...
    logdata_fxp_ldpc_base32, logdata_fxp_ldpc_approx32,...
    modul, EbN0, iter)
    
    fxp = "FXP16";

    % Load colors from colors.m
    run("colors.m");

    % Use LaTeX for plots
    set(0, 'defaultTextInterpreter','latex');
    set(0, 'defaultLegendInterpreter', 'latex');

    % Calculate theoretical BER values for given modulation and AWGN Channel
    EbN0_fit = EbN0(1):1:EbN0(end);
    BER_theor = berawgn(EbN0_fit, 'qam', modul);
    % BER_theor = berfading(EbN0_fit, 'qam', modul, 4);

    % Add markers for calculated datapoints
    figure;
    semilogy(EbN0_fit, BER_theor + eps, ...
        "-o", "MarkerSize", 7, "LineWidth", 1.0, ...
        "Color", teal50, ...
        "DisplayName", "Theoretical Reference");
        % "Color", sea_green,...
    hold on;

    % ---------------------------------------------------------------------
    % Import BER FLP implementation reference (no FEC)
    flp_path = "data/approx/QAM" + modul + "/log_flp_nofec_qam" + modul + "/log_data.txt";
%     flp_path = "data/approx/log_flp_nofec_qam16/log_data.txt";
    refdata = readtable(flp_path);

    % Extract reference BER for specific Modulation and 0 LDPC iterations
    idx = find(refdata.Modulation == modul & refdata.LDPC_Iter == 0);
        
    % Create array with EbN0dB noise and BER value
    y_flp(:,1) = refdata.EbN0dB(idx);
    y_flp(:,2) = refdata.BER(idx);

    % Add markers for calculated datapoints
    semilogy(y_flp(:,1), y_flp(:,2) + eps, ...
        "--*", "MarkerSize", 7, "LineWidth", 1.0, ...
        "MarkerFaceColor", red90, "Color", red90,...
        "DisplayName", "FLP64-B64, w/o FEC");
        % "MarkerFaceColor", dark_red, "Color", dark_red,...
    hold on;

    % -------------------------

    % --------------------------------------------
    % Import BER FLP implementation reference (LDPC)
    flp_path = "data/approx/QAM" + modul + "/log_flp_ldpc_qam" + modul + "/log_data.txt";
%     flp_path = "data/approx/log_flp_ldpc_qam16/log_data.txt";
    refdata = readtable(flp_path);

    % Extract reference BER for specific Modulation and 0 LDPC iterations
    idx_1 = find(refdata.Modulation == modul & refdata.LDPC_Iter == 50);
%     idx_1 = find(refdata.Modulation == modul & refdata.LDPC_Iter == 30);
        
    % Create array with EbN0dB noise and BER value
    y_flp(:,1) = refdata.EbN0dB(idx_1);
    y_flp(:,2) = refdata.BER(idx_1);

    % Add markers for calculated datapoints
    semilogy(y_flp(:,1), y_flp(:,2) + eps, ...
        "--x", "MarkerSize", 7, "LineWidth", 1.0, ...
        "MarkerFaceColor", purple50, "Color", purple50,...
        "DisplayName", "FLP64-B64 LDPC 50 Iter.");
        % "MarkerFaceColor", purple, "Color", purple,...
    hold on;


    % ---------------------------------------------------------------------
    % Add FXP Base model without FEC (S2.14 - MUL32)

    % Extract data from table for specific Modulation and LDPC iterations
    idx_1 = find(logdata_fxp_nofec_base32.Modulation == modul & logdata_fxp_nofec_base32.LDPC_Iter == 0);

    % Create array with EbN0dB noise and BER value
    y_fxp_1(:,1) = logdata_fxp_nofec_base32.EbN0dB(idx_1);
    y_fxp_1(:,2) = logdata_fxp_nofec_base32.BER(idx_1);

    % Plot BER relative to Eb/N0
    semilogy(y_fxp_1(:,1), y_fxp_1(:,2) + eps, ...
        "--square", "MarkerSize", 6, "LineWidth", 1.0, ...
        "Color", blue80,...
        "DisplayName", fxp + "-B32, w/o FEC");
        % "Color", navy_blue,...
    hold on;

    % ---------------------------------------------------------------------
    % Add FXP Approximate model without FEC (S2.14 - MUL32)
    
    % Extract data from table for specific Modulation and LDPC iterations
    idx_2 = find(logdata_fxp_nofec_approx32.Modulation == modul & logdata_fxp_nofec_approx32.LDPC_Iter == 0);

    % Create array with EbN0dB noise and BER value
    y_fxp_2(:,1) = logdata_fxp_nofec_approx32.EbN0dB(idx_2);
    y_fxp_2(:,2) = logdata_fxp_nofec_approx32.BER(idx_2);

    % Plot BER relative to Eb/N0
    semilogy(y_fxp_2(:,1), y_fxp_2(:,2) + eps, ...
        "-.v", "MarkerSize", 6, "LineWidth", 1.0, ...
        "Color", magenta70,...
        "DisplayName", fxp + "-A32, w/o FEC");
        % "Color", steel_blue,...
    hold on;

    
    % ---------------------------------------------------------------------
    % Add FXP Base model with LDPC (S2.14 - MUL32)
    
    % Extract data from table for specific Modulation and LDPC iterations
    idx_3 = find(logdata_fxp_ldpc_base32.Modulation == modul & logdata_fxp_ldpc_base32.LDPC_Iter == iter);

    % Create array with EbN0dB noise and BER value
    y_fxp_3(:,1) = logdata_fxp_ldpc_base32.EbN0dB(idx_3);
    y_fxp_3(:,2) = logdata_fxp_ldpc_base32.BER(idx_3);

    % Plot BER relative to Eb/N0
    semilogy(y_fxp_3(:,1), y_fxp_3(:,2) + eps, ...
        "--diamond", "MarkerSize", 6, "LineWidth", 1.0, ...
        "Color", blue80,...
        "DisplayName", fxp + "-B32 LDPC " + iter + " Iter.");
        % "Color", navy_blue,...
    hold on;


    % ---------------------------------------------------------------------
    % Add FXP Appproximate model with LDPC (S2.14 - MUL32)
    
    % Extract data from table for specific Modulation and LDPC iterations
    idx_4 = find(logdata_fxp_ldpc_approx32.Modulation == modul & logdata_fxp_ldpc_approx32.LDPC_Iter == iter);

    % Create array with EbN0dB noise and BER value
    y_fxp_4(:,1) = logdata_fxp_ldpc_approx32.EbN0dB(idx_4);
    y_fxp_4(:,2) = logdata_fxp_ldpc_approx32.BER(idx_4);

    % Plot BER relative to Eb/N0
    semilogy(y_fxp_4(:,1), y_fxp_4(:,2) + eps, ...
        "-.^", "MarkerSize", 6, "LineWidth", 1.0, ...
        "Color", magenta70,...
        "DisplayName", fxp + "-A32 LDPC " + iter + " Iter.");
        % "Color", steel_blue,...
    hold on;


    % ---------------------------------------------------------------------
    % For y axis values range
    ylim([10^(-5) 1]);

    % Add title and labels to plot
    %---------------------------------
    % title("QAM" + modul + ...
    %         " (32 Blocks, N=64800, Rate=3/4)");
    grid on;
    
    xlabel("$E_b/N_0$ [dB]");
    ylabel("Bit Error Rate (BER)");

    legend("show", "Location", "southwest");
    
    set(gca, 'TickLabelInterpreter','latex');

    set(gcf, 'Position', [10, 10, 570, 400]);

    % Save plot
    % saveas(gca, "plots/EbN0_BER_comb_QAM" + modul, "epsc");
    saveas(gcf, "plots/EbN0_BER_comb_QAM" + modul + ".pdf");
    system("sudo pdfcrop plots/EbN0_BER_comb_QAM" + modul + ".pdf plots/EbN0_BER_comb_QAM" + modul + ".pdf");
end
