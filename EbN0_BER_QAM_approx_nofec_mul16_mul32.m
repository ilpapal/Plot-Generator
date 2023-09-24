% Function to plot all BER values for one modulation
function EbN0_BER_QAM_approx_nofec_mul16_mul32( ...
    logdata_fxp_base16, logdata_fxp_approx16,...
    logdata_fxp_base32, logdata_fxp_approx32,...
    modul, EbN0, impl_name, bits)

    % Define implementation input bits
    if bits == 16
        fxp = "FXP16";
    elseif bits == 8
        fxp = "FXP8";
    end

    % Load colors from colors.m
    run("colors.m");

    % Use LaTeX for plots
    set(0, 'defaultTextInterpreter','latex');
    set(0, 'defaultLegendInterpreter', 'latex');

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
    flp_path = "data/approx/QAM64/log_flp_nofec_qam" + modul + "/log_data.txt";
    refdata = readtable(flp_path);

    % Extract reference BER for specific Modulation and 0 LDPC iterations
    idx_1 = find(refdata.Modulation == modul & refdata.LDPC_Iter == 0);
        
    % Create array with EbN0dB noise and BER value
    y_flp(:,1) = refdata.EbN0dB(idx_1);
    y_flp(:,2) = refdata.BER(idx_1);

    % Add markers for calculated datapoints
    semilogy(y_flp(:,1), y_flp(:,2) + eps, ...
        "--*", "MarkerSize", 7, "LineWidth", 1.0, ...
        "MarkerFaceColor", red90, "Color", red90,...
        "DisplayName", "FLP64-B64, w/o FEC");
    hold on;


    % ---------------------------------------------------------------------
    % Add FXP Base model (S2.14 - MUL16)

    % Extract data from table for specific Modulation and LDPC iterations
    idx_1 = find(logdata_fxp_base16.Modulation == modul & logdata_fxp_base16.LDPC_Iter == 0);

    % Create array with EbN0dB noise and BER value
    y_fxp16(:,1) = logdata_fxp_base16.EbN0dB(idx_1);
    y_fxp16(:,2) = logdata_fxp_base16.BER(idx_1);

    % Plot BER relative to Eb/N0
    semilogy(y_fxp16(:,1), y_fxp16(:,2) + eps, ...
        "--square", "MarkerSize", 6, "LineWidth", 1.0, ...
        "Color", blue80,...
        "DisplayName", fxp + "-B16, w/o FEC");
    hold on;
    
    
    % ---------------------------------------------------------------------
    % Add FXP Base model (S2.14 - MUL32)
    
    % Extract data from table for specific Modulation and LDPC iterations
    idx_1 = find(logdata_fxp_base32.Modulation == modul & logdata_fxp_base32.LDPC_Iter == 0);

    % Create array with EbN0dB noise and BER value
    y_fxp32(:,1) = logdata_fxp_base32.EbN0dB(idx_1);
    y_fxp32(:,2) = logdata_fxp_base32.BER(idx_1);

    % Plot BER relative to Eb/N0
    semilogy(y_fxp32(:,1), y_fxp32(:,2) + eps, ...
        "--^", "MarkerSize", 6, "LineWidth", 1.0, ...
        "Color", blue80,...
        "DisplayName", fxp + "-B32, w/o FEC");
    hold on;


    % ---------------------------------------------------------------------
    % Add FXP Approximate model (S2.14 - MUL16)

    % Extract data from table for specific Modulation and LDPC iterations
    idx_1 = find(logdata_fxp_approx16.Modulation == modul & logdata_fxp_approx16.LDPC_Iter == 0);

    % Create array with EbN0dB noise and BER value
    y_fxp_a16(:,1) = logdata_fxp_approx16.EbN0dB(idx_1);
    y_fxp_a16(:,2) = logdata_fxp_approx16.BER(idx_1);

    % Plot BER relative to Eb/N0
    semilogy(y_fxp_a16(:,1), y_fxp_a16(:,2) + eps, ...
        "-.+", "MarkerSize", 6, "LineWidth", 1.0, ...
        "Color", magenta70,...
        "DisplayName", fxp + "-A16, w/o FEC");
    hold on;
    
    
    % ---------------------------------------------------------------------
    % Add FXP Approximate model (S2.14 - MUL32)
    
    % Extract data from table for specific Modulation and LDPC iterations
    idx_1 = find(logdata_fxp_approx32.Modulation == modul & logdata_fxp_approx32.LDPC_Iter == 0);

    % Create array with EbN0dB noise and BER value
    y_fxp_a32(:,1) = logdata_fxp_approx32.EbN0dB(idx_1);
    y_fxp_a32(:,2) = logdata_fxp_approx32.BER(idx_1);

    % Plot BER relative to Eb/N0
    semilogy(y_fxp_a32(:,1), y_fxp_a32(:,2) + eps, ...
        "-.v", "MarkerSize", 6, "LineWidth", 1.0, ...
        "Color", magenta70,...
        "DisplayName", fxp + "-A32, w/o FEC");
    hold on;


    % ---------------------------------------------------------------------
    % For y axis values range
    ylim([10^(-5) 1]);

    % Add title and labels to plot
    % title("QAM" + modul + ...
    %         " (32 Blocks, N=64800)");
    grid on;

%     " (32 Blocks, N=64800, " + impl_name + ")");
    
    xlabel("$E_b/N_0$ [dB]");
    ylabel("Bit Error Rate (BER)");

    legend("show", "Location", "southwest");
    
    set(gca, 'TickLabelInterpreter','latex');
    set(gcf, 'Position', [10, 10, 570, 400]);

    % Save plot
    save_path = "plots/EbN0_BER_nofec_fxp" + bits + "_QAM" + modul + ".pdf";
    system("sudo rm " + save_path);
    saveas(gcf, save_path);
    system("sudo pdfcrop " + save_path + " " + save_path)
end