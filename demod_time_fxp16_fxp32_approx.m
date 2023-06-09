% Function to generate demodulator bar graph with LLR Mean relative erro
function demod_time_fxp16_fxp32_approx(noise, iter, path_fxp16_orig, path_fxp16_approx, path_fxp32_orig, path_fxp32_approx)
    % Load colors from colors.m
    run("colors.m");
    
    % Use LaTeX for plots
    set(0, 'defaultTextInterpreter','latex');
    set(0, 'defaultLegendInterpreter', 'latex');

    % Number of different modulations
    % M = 2;
    
    % Import data from log_data.txt file
    logdata_fxp16_orig = readtable(path_fxp16_orig + "/log_data.txt");
    logdata_fxp16_approx = readtable(path_fxp16_approx + "/log_data.txt");
    logdata_fxp32_orig = readtable(path_fxp32_orig + "/log_data.txt");
    logdata_fxp32_approx = readtable(path_fxp32_approx + "/log_data.txt");

    % Extract data from table for specific noise and LDPC iterations
    idx_fxp16_orig = find(logdata_fxp16_orig.EbN0dB == noise & logdata_fxp16_orig.LDPC_Iter == iter);
    idx_fxp16_approx = find(logdata_fxp16_approx.EbN0dB == noise & logdata_fxp16_approx.LDPC_Iter == iter);

    idx_fxp32_orig = find(logdata_fxp32_orig.EbN0dB == noise & logdata_fxp32_orig.LDPC_Iter == iter);
    idx_fxp32_approx = find(logdata_fxp32_approx.EbN0dB == noise & logdata_fxp32_approx.LDPC_Iter == iter);
    
    % Create array with base and optimized time values
    y(1) = logdata_fxp16_orig.Demod_Base(idx_fxp16_orig);

    y(2) = logdata_fxp16_orig.Demod_Opt(idx_fxp16_orig);
    y(3) = logdata_fxp16_approx.Demod_Opt(idx_fxp16_approx);
    
    y(4) = logdata_fxp32_orig.Demod_Opt(idx_fxp32_orig);
    y(5) = logdata_fxp32_approx.Demod_Opt(idx_fxp32_approx);
    
    % Create array with xaxis labels
%     x_labels(idx_fxp16_orig) = "QAM" + logdata_fxp16_orig.Modulation(idx_fxp16_orig);
%     x_labels = rmmissing(x_labels);
    
    % Bar graph
    figure;
%     colororder([0 0 0]);
%     x = ["FLP Base" "FXP S2.14 Base" "FXP S2.14 Approx"]; 
    b = bar(1, y);

    xticklabels({});

    b(1).FaceColor = navy_blue;
    b(2).FaceColor = steel_blue;
    b(3).FaceColor = powder_blue;
    b(4).FaceColor = sky_blue;
    b(5).FaceColor = royal_blue; 

    
    % Add speedup for fxp16 original
    xtips1 = b(2).XEndPoints;
    ytips1 = b(2).YEndPoints;
    labels1 = string("$\times$" + logdata_fxp16_orig.Demod_Speedup(idx_fxp16_orig)');
    text(xtips1, ytips1, labels1, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 10, "Rotation", 45);
    
    % Add speedup for fxp16 approximate
    xtips2 = b(3).XEndPoints;
    ytips2 = b(3).YEndPoints;
    labels2 = string("$\times$" + logdata_fxp16_approx.Demod_Speedup(idx_fxp16_approx)');
    text(xtips2, ytips2, labels2, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 10, "Rotation", 45);

    % mul32
    xtips3 = b(4).XEndPoints;
    ytips3 = b(4).YEndPoints;
    labels3 = string("$\times$" + logdata_fxp32_orig.Demod_Speedup(idx_fxp32_orig)');
    text(xtips3, ytips3, labels3, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 10, "Rotation", 45);
    
    % Add speedup for fxp16 approximate
    xtips4 = b(5).XEndPoints;
    ytips4 = b(5).YEndPoints;
    labels4 = string("$\times$" + logdata_fxp32_approx.Demod_Speedup(idx_fxp32_approx)');
    text(xtips4, ytips4, labels4, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 10, "Rotation", 45);

    %}

    ylabel("Execution time [ms]");

    %{
    % Plot speedup for fxp16 (original: dark_red & coral)
    yyaxis right;
    plot(logdata_fxp16_orig.Demod_Speedup(idx_fxp16_orig), "--^",...
        "MarkerSize", 5,...
        "MarkerFaceColor", dark_red, "Color", dark_red);
    hold on;

    plot(logdata_fxp16_approx.Demod_Speedup(idx_fxp16_approx), ":^",...
        "MarkerSize", 5,...
        "MarkerFaceColor", dark_red, "Color", dark_red);
    %}

    % Add x and y axis labels
    % xticklabels(x_labels);
    xlabel("Implementation");
%     ylabel("Speedup");

    % Misc plot settings
    title("Demodulation QAM16 (N = 64800)");
    grid on;
%     xlabel("Modulation type");
    legend("FLP Base", ...
            "FXP S2.14 NEON (MUL16, Base)", "FXP S2.14 NEON (MUL16, Approx)", ...
            "FXP S2.14 NEON (MUL32, Base)", "FXP S2.14 NEON (MUL32, Approx)", ...
        "Location", "northeast");

    set(gca, 'TickLabelInterpreter','latex');

    saveas(gca, "plots/demod_plot_approx_EbN0dB_" + noise, "epsc");
    save("data");
end