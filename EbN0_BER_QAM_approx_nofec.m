% Function to plot all BER values for one modulation
function EbN0_BER_QAM_approx_nofec( ...
    logdata_fxp_base, logdata_fxp_approx,...
    modul, iter, EbN0, impl_name)

    % Load colors from colors.m
    run("colors.m");

    % Use LaTeX for plots
    set(0, 'defaultTextInterpreter','latex');
    set(0, 'defaultLegendInterpreter', 'latex');
    
    % Array with different line styles
    lines_1 = ["--square" "-.square" ":square"];
    lines_2 = ["-.^" "--^" ":^"];

    % Calculate theoretical BER values for given modulation and AWGN Channel
    EbN0_fit = EbN0(1):1:EbN0(end);
    BER_theor = berawgn(EbN0_fit, 'qam', modul);

    % Add markers for calculated datapoints
    figure;
    semilogy(EbN0_fit, BER_theor + eps, ...
        "-o", "MarkerSize", 7, "LineWidth", 1.0, ...
        "Color", teal50,...
        "DisplayName", "Theoretical Reference");
    hold on;

    % Import BER FLP implementation reference 
    flp_path = "data/approx/log_flp_nofec_qam" + modul + "/log_data.txt";
    refdata = readtable(flp_path);

    % Extract reference BER for specific Modulation and 40 LDPC iterations
    idx_1 = find(refdata.Modulation == modul & refdata.LDPC_Iter == 0);
        
    % Create array with EbN0dB noise and BER value
    y_flp(:,1) = refdata.EbN0dB(idx_1);
    y_flp(:,2) = refdata.BER(idx_1);

    % Add markers for calculated datapoints
    semilogy(y_flp(:,1), y_flp(:,2) + eps, ...
        "--*", "MarkerSize", 7, "LineWidth", 1.0, ...
        "MarkerFaceColor", red90, "Color", red90,...
        "DisplayName", "FLP64-B64");
    hold on;

    % Add FXP Base model (S2.14)
    % For loop
    for i=1:length(iter)
        % Extract data from table for specific Modulation and LDPC iterations
        idx_1 = find(logdata_fxp_base.Modulation == modul & logdata_fxp_base.LDPC_Iter == iter(i));

        % Create array with EbN0dB noise and BER value
        y_fxp16(:,1) = logdata_fxp_base.EbN0dB(idx_1);
        y_fxp16(:,2) = logdata_fxp_base.BER(idx_1);

        % Plot BER relative to Eb/N0
        semilogy(y_fxp16(:,1), y_fxp16(:,2) + eps, ...
            lines_1(i), "MarkerSize", 7, "LineWidth", 1.0, ...
            "Color", blue80,...
            "DisplayName", "FXP16-B16");
        hold on;
    end
    
    % Add FXP Approximate model (S2.14)
    for i=1:length(iter)
        % Extract data from table for specific Modulation and LDPC iterations
        idx_2 = find(logdata_fxp_approx.Modulation == modul & logdata_fxp_approx.LDPC_Iter == iter(i));
        
        % Create array with EbN0dB noise and BER value
        y_fxp16_approx(:,1) = logdata_fxp_approx.EbN0dB(idx_2);
        y_fxp16_approx(:,2) = logdata_fxp_approx.BER(idx_2);

        % Plot BER relative to Eb/N0
        semilogy(y_fxp16_approx(:,1), y_fxp16_approx(:,2) + eps, ...
            lines_2(i), "MarkerSize", 6, "LineWidth", 1.0, ...
            "Color", magenta70,...
            "DisplayName", "FXP16-A16");
        hold on;
    end

    % For y axis values range
    ylim([10^(-5) 1]);

    % Add title and labels to plot
    % title("QAM" + modul + ...
    %         " (32 Blocks, N=64800, " + impl_name + ")");
    grid on;
    xlabel("$E_b/N_0$ [dB]");
    ylabel("Bit Error Rate (BER)");
%     legend("show", "Location", "northeast");
    legend("show", "Location", "southwest");
    
    set(gca, 'TickLabelInterpreter','latex');

    % Save plot
    saveas(gca, "plots/EbN0_BER_" + impl_name + "_QAM" + modul, "epsc");
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