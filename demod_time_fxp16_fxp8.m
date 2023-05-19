% Function to generate demodulator bar graph with LLR Mean relative erro
function demod_time_fxp16_fxp8(noise, iter, path_fxp16, path_fxp8)
    % Load colors from colors.m
    run("colors.m");
    
    % Number of different modulations
    M = 5;
    
    % Import data from log_data.txt file
    logdata_fxp16 = readtable(path_fxp16 + "/log_data.txt");
    logdata_fxp8 = readtable(path_fxp8 + "/log_data.txt");
    
    % Extract data from table for specific noise and LDPC iterations
    idx_fxp16 = find(logdata_fxp16.EbN0dB == noise & logdata_fxp16.LDPC_Iter == iter);
    idx_fxp8 = find(logdata_fxp8.EbN0dB == noise & logdata_fxp8.LDPC_Iter == iter);
    
    % Create array with base and optimized time values
    y(1:M,1) = logdata_fxp16.Demod_Base(idx_fxp16);
    y(1:M,2) = logdata_fxp16.Demod_Opt(idx_fxp16);
    y(1:M,3) = logdata_fxp8.Demod_Opt(idx_fxp8);
    
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
    
    % Add speedup for fxp16
    xtips1 = b(2).XEndPoints;
    ytips1 = b(2).YEndPoints;
    labels1 = string("x" + logdata_fxp16.Demod_Speedup(idx_fxp16)');
    text(xtips1, ytips1, labels1, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 7, "Rotation", 45);
    
    % Add speed for fxp8
    xtips2 = b(3).XEndPoints;
    ytips2 = b(3).YEndPoints;
    labels2 = string("x" + logdata_fxp8.Demod_Speedup(idx_fxp8)');
    text(xtips2, ytips2, labels2, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 7, "Rotation", 45);

    ylabel("Execution time [ms]");

    % Plot speedup for fxp16
    yyaxis right;
    plot(logdata_fxp16.Demod_Speedup(idx_fxp16), "--^",...
        "MarkerSize", 7,...
        "MarkerFaceColor", dark_red, "Color", dark_red);
    hold on;

    plot(logdata_fxp8.Demod_Speedup(idx_fxp8), ":^",...
        "MarkerSize", 7,...
        "MarkerFaceColor", dark_red, "Color", dark_red);

    % Add x and y axis labels
    xticklabels(x_labels);
    ylabel("Speedup");

    % Misc plot settings
    title("Demodulation FLP/FXP (Eb/N0=" + noise + "dB, 8 Blocks)");
    grid on;
    xlabel("Modulation type");
    legend("FLP Base", "FXP S2.14 NEON", "FXP S2.6 NEON", ...
        "FXP S2.14 Speedup", "FXP S2.6 Speedup",...
        "Location", "northwest");

    saveas(gca, "plots/demod_plot_EbN0dB_" + noise, "epsc");
    save("data");
end