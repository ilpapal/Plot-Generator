% Function to plot all BER values for one modulation
function EbN0_BER_QAM_approx_ldpc( ...
    logdata_fxp_base, logdata_fxp_approx,...
    modul, EbN0, iter, impl_name, bits, mul)

    % Define implementation input bits
    if bits == 16
        fxp = "FXP16";
    elseif bits == 8
        fxp = "FXP8";
    end

    % Define implementation multiplication
    if mul == 16
        mul = "16";
    elseif mul == 32
        mul = "32";
    end

    % Load colors from colors.m
    run("colors.m");

    % Use LaTeX for plots
    set(0, 'defaultTextInterpreter','latex');
    set(0, 'defaultLegendInterpreter', 'latex');

    % Array with different line styles
    lines_1 = ["--square" "-.^" ":>"];
    lines_2 = ["--diamond" "-.x" ":+"];

    % Calculate theoretical BER values for given modulation and AWGN Channel
    EbN0_fit = EbN0(1):1:EbN0(end);
    BER_theor = berawgn(EbN0_fit, 'qam', modul);

    % Add markers for calculated datapoints
    figure;
    semilogy(EbN0_fit, BER_theor + eps, ...
        "-o", "MarkerSize", 7, "LineWidth", 1.0, ...
        "Color", teal50,...
        "DisplayName", "Theoretical Reference");
        % "Color", sea_green,...
    hold on;

    % ---------------------------------------------------------------------
    % Import BER FLP implementation reference 
    flp_path = "data/approx/QAM64/log_flp_ldpc_qam" + modul + "/log_data.txt";
    refdata = readtable(flp_path);

    % Extract reference BER for specific Modulation and 0 LDPC iterations
    idx_1 = find(refdata.Modulation == modul & refdata.LDPC_Iter == 50);
        
    % Create array with EbN0dB noise and BER value
    y_flp(:,1) = refdata.EbN0dB(idx_1);
    y_flp(:,2) = refdata.BER(idx_1);

    % Add markers for calculated datapoints
    semilogy(y_flp(:,1), y_flp(:,2) + eps, ...
        "--*", "MarkerSize", 7, "LineWidth", 1.0, ...
        "MarkerFaceColor", red90, "Color", red90,...
        "DisplayName", "FLP64-B64 LDPC 50 Iter.");
        % "Color", dark_red,...
    hold on;


    % ---------------------------------------------------------------------
    % Add FXP Base model (S2.14)

    for i=1:length(iter)
        % Extract data from table for specific Modulation and LDPC iterations
        idx_1 = find(logdata_fxp_base.Modulation == modul & logdata_fxp_base.LDPC_Iter == iter(i));
    
        % Create array with EbN0dB noise and BER value
        y_fxp(:,1) = logdata_fxp_base.EbN0dB(idx_1);
        y_fxp(:,2) = logdata_fxp_base.BER(idx_1);
    
        % Plot BER relative to Eb/N0
        semilogy(y_fxp(:,1), y_fxp(:,2) + eps, ...
            lines_1(i), "MarkerSize", 6, "LineWidth", 1.0, ...
            "Color", blue80,...
            "DisplayName", fxp + "-B" + mul + " LDPC " + iter(i) + " Iter.");
        hold on;
        % "Color", navy_blue,...
    end
    
   
    % ---------------------------------------------------------------------
    % Add FXP Approximate model (S2.14)

    for i=1:length(iter)
        % Extract data from table for specific Modulation and LDPC iterations
        idx_1 = find(logdata_fxp_approx.Modulation == modul & logdata_fxp_approx.LDPC_Iter == iter(i));
    
        % Create array with EbN0dB noise and BER value
        y_fxp_a(:,1) = logdata_fxp_approx.EbN0dB(idx_1);
        y_fxp_a(:,2) = logdata_fxp_approx.BER(idx_1);
    
        % Plot BER relative to Eb/N0
        semilogy(y_fxp_a(:,1), y_fxp_a(:,2) + eps, ...
            lines_2(i), "MarkerSize", 6, "LineWidth", 1.0, ...
            "Color", magenta70,...
            "DisplayName", fxp + "-A" + mul + " LDPC " + iter(i) + " Iter.");
        hold on;
        % "Color", steel_blue,...
    end

    % ---------------------------------------------------------------------
    % For y axis values range
    ylim([10^(-5) 1]);

    % Add title and labels to plot
    % title("QAM" + modul + ...
    %         " (32 Blocks, N=64800, Rate=3/4)");
    grid on;
    
    xlabel("$E_b/N_0$ [dB]");
    ylabel("Bit Error Rate (BER)");

    legend("show", "Location", "southwest");
    
    set(gca, 'TickLabelInterpreter','latex');
    set(gcf, 'Position', [10, 10, 570, 400]);

    % Save plot
    % saveas(gca, "plots/EbN0_BER_ldpc_fxp" + bits + "_" + mul + "_QAM" + modul, "epsc");
    save_path = "plots/EbN0_BER_ldpc_fxp" + bits + "_" + mul + "_QAM" + modul + ".pdf";
    system("sudo rm " + save_path);
    saveas(gcf, save_path);
    system("sudo pdfcrop " + save_path + " " + save_path);

end