% Function to generate demodulator bar graph with LLR Mean relative erro
function demod_time_llr_plot(noise, iter, path)
    % Load colors from colors.m
    run("colors.m");
    
    % Number of different modulations
    M = 5;
    
    % Import data from log_data.txt file
    logdata = readtable(path + '/log_data.txt');
    
    % Extract data from table for specific noise and LDPC iterations
    idx = find(logdata.EbN0dB == noise & logdata.LDPC_Iter == iter);
    
    % Create array with base and optimized time values
    y(1:M,1) = logdata.Demod_Base(idx);
    y(1:M,2) = logdata.Demod_Opt(idx);
    
    % Create array with xaxis labels
    x_labels(idx) = "QAM" + logdata.Modulation(idx);
    x_labels = rmmissing(x_labels);
    
    % Bar graph
    figure;

    % Create axes
    colororder([0 0 0]);

    yyaxis right;
    b = bar(y);
    b(1).FaceColor = navy_blue;
    b(2).FaceColor = steel_blue;
    
    % Add speedup 
    xtips1 = b(2).XEndPoints;
    ytips1 = b(2).YEndPoints;
    labels1 = string("x" + logdata.Demod_Speedup(idx)');
    text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom', 'FontSize',7);
    
%     colororder("k");
%     yyaxis left;
    ylabel("Execution time [ms]");
    
    % Add x axis labels
    xticklabels(x_labels);
    
    % Import data from llr log file for spedific noise and Modulation
    llr_data_file = path + "/llr_" + logdata.Modulation(idx) + "_" + noise + ".txt";
    
    % Compute for each modulation llr error 
    for i = 1:M
        llrdata = readtable(llr_data_file(i));
    
        % Get variables from log file
        llr_d = table2array(llrdata(:, 1));
        llr_fp = table2array(llrdata(:, 2));
        
        % Calculate error of double and fixed point datatype
        error = (llr_d - llr_fp)./(llr_d).*100;
        
        % Skip error calculation when denominator is zero
        error(llr_d == 0) = [];
        
        % When both values are zero, error is zero
        error(llr_d == 0 & llr_fp == 0) = 0;
        
        % We only need absolute error value
        error = abs(error);
    
        % Print mean value of error
        disp("Error mean value: " + mean(error));
    
        % Append mean value of error to array
        llr(i) = mean(error);
    end
    
%     yyaxis right;
    yyaxis left;
    % plot(table2array(llr), "-^",...
    plot(llr, "-^",...
        "MarkerSize", 7,...
        "MarkerFaceColor", dark_red, "Color", dark_red);
    ylabel("Mean Relative Error [%]");
    
    % Misc plot settings
    title("Demodulator FXP S2.14 (Eb/N0=" + noise + "dB, 8 Blocks)");
    grid on;
    xlabel("Modulation type");
%     legend("FLP Base", "FXP S2.14 NEON", "LLR Mean Relative Error", "Location", "northwest");
    legend("LLR Mean Relative Error", "FLP Base", "FXP S2.14 NEON", ...
        "Location", "southoutside", "Orientation", "horizontal");

    set(gca, "SortMethod", "Depth");
    set(gcf, "renderer", "Painters");
    saveas(gca, "plots/demod_plot_EbN0dB_" + noise, "epsc");
    save("data");
end