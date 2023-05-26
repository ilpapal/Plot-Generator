% Function to generate demodulator bar graph with LLR Mean relative erro
function demod_time_fxp16_fxp8_precision(noise, iter, path_fxp16, path_fxp8, path_fxp16_p, path_fxp8_p)
    % Load colors from colors.m
    run("colors.m");
    
    % Number of different modulations
    M = 5;
    
    % Import data from log_data.txt file
    logdata_fxp16 = readtable(path_fxp16 + "/log_data.txt");
    logdata_fxp8 = readtable(path_fxp8 + "/log_data.txt");
    logdata_fxp16_p = readtable(path_fxp16_p + "/log_data.txt");
    logdata_fxp8_p = readtable(path_fxp8_p + "/log_data.txt");
    
    % Extract data from table for specific noise and LDPC iterations
    idx_fxp16 = find(logdata_fxp16.EbN0dB == noise & logdata_fxp16.LDPC_Iter == iter);
    idx_fxp8 = find(logdata_fxp8.EbN0dB == noise & logdata_fxp8.LDPC_Iter == iter);
    idx_fxp16_p = find(logdata_fxp16_p.EbN0dB == noise & logdata_fxp16_p.LDPC_Iter == iter);
    idx_fxp8_p = find(logdata_fxp8_p.EbN0dB == noise & logdata_fxp8_p.LDPC_Iter == iter);
    
    % Create array with base and optimized time values
    y(1:M,1) = logdata_fxp16.Demod_Base(idx_fxp16);
    y(1:M,2) = logdata_fxp16.Demod_Opt(idx_fxp16);
    y(1:M,3) = logdata_fxp8.Demod_Opt(idx_fxp8);
    y(1:M,4) = logdata_fxp16_p.Demod_Opt(idx_fxp16_p);
    y(1:M,5) = logdata_fxp8_p.Demod_Opt(idx_fxp8_p);
    
    % Create array with xaxis labels
    x_labels(idx_fxp16) = "QAM" + logdata_fxp16.Modulation(idx_fxp16);
    x_labels = rmmissing(x_labels);
    
    % Bar graph
    figure;
    colororder([0 0 0]);
    b = bar(y);
    b(1).FaceColor = navy_blue;
    b(2).FaceColor = steel_blue;
    b(3).FaceColor = powder_blue;
    b(4).FaceColor = deep_sky_blue;
    b(5).FaceColor = cornflower_blue;

    % Add speedup for fxp16
    xtips1 = b(2).XEndPoints;
    ytips1 = b(2).YEndPoints;
    labels1 = string("x" + logdata_fxp16.Demod_Speedup(idx_fxp16)');
    text(xtips1, ytips1, labels1, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 5, "Rotation", 45);
    
    % Add speed for fxp8
    xtips2 = b(3).XEndPoints;
    ytips2 = b(3).YEndPoints;
    labels2 = string("x" + logdata_fxp8.Demod_Speedup(idx_fxp8)');
    text(xtips2, ytips2, labels2, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 5, "Rotation", 45);

    % Add speedup for fxp16 precision
    xtips1 = b(4).XEndPoints;
    ytips1 = b(4).YEndPoints;
    labels3 = string("x" + logdata_fxp16_p.Demod_Speedup(idx_fxp16_p)');
    text(xtips1, ytips1, labels3, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 5, "Rotation", 45);

    % Add speed for fxp8 precision
    xtips2 = b(5).XEndPoints;
    ytips2 = b(5).YEndPoints;
    labels4 = string("x" + logdata_fxp8_p.Demod_Speedup(idx_fxp8_p)');
    text(xtips2, ytips2, labels4, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 5, "Rotation", 45);

    ylabel("Execution time [ms]");

    % Plot speedup for fxp16 (original: dark_red & coral)
    yyaxis right;
    plot(logdata_fxp16.Demod_Speedup(idx_fxp16), "--^",...
        "MarkerSize", 5,...
        "MarkerFaceColor", dark_red, "Color", dark_red);
    hold on;

    plot(logdata_fxp8.Demod_Speedup(idx_fxp8), ":^",...
        "MarkerSize", 5,...
        "MarkerFaceColor", dark_red, "Color", dark_red);

    plot(logdata_fxp16_p.Demod_Speedup(idx_fxp16_p), "--^",...
        "MarkerSize", 5,...
        "MarkerFaceColor", sea_green, "Color", sea_green);

    plot(logdata_fxp8_p.Demod_Speedup(idx_fxp8_p), ":^",...
        "MarkerSize", 5,...
        "MarkerFaceColor", sea_green, "Color", sea_green);

    % Add x and y axis labels
    xticklabels(x_labels);
    ylabel("Speedup");

    % Misc plot settings
    title("Demodulation FLP/FXP (Eb/N0=" + noise + "dB, 8 Blocks)");
    grid on;
    xlabel("Modulation type");
    legend("FLP Base", ...
            "FXP S2.14 NEON (Optimal)", "FXP S2.6 NEON (Optimal)", ...
           "FXP S2.14 NEON (Precision)", "FXP S2.6 NEON (Precision)", ...
           "FXP S2.14 Speedup (Optimal)", "FXP S2.6 Speedup (Optimal)",...
           "FXP S2.14 Speedup (Precision)", "FXP S2.6 Speedup (Precision)",...
        "Location", "southoutside", "NumColumns", 2, "FontSize", 7);

    saveas(gca, "plots/demod_plot_opt_prec_EbN0dB_" + noise, "epsc");
    save("data");
end