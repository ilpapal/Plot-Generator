% Function to generate demodulator bar graph with LLR Mean relative erro
function ldpc_time_llr_plot(noise, iter1, iter2, iter3, path)
    % Load colors from colors.m
    run("colors.m");

    % Number of different modulations
    M = 5;
    
    % Import data from log_data.txt file
    logdata = readtable(path + '/log_data.txt');
    
    % Extract data from table for specific noise and LDPC iterations
    idx1 = find(logdata.EbN0dB == noise & logdata.LDPC_Iter == iter1);
    idx2 = find(logdata.EbN0dB == noise & logdata.LDPC_Iter == iter2);
    idx3 = find(logdata.EbN0dB == noise & logdata.LDPC_Iter == iter3);
    
    % Create array with time values for each iteration
    y(1:M,1) = logdata.Decoder(idx1);
    y(1:M,2) = logdata.Decoder(idx2);
    y(1:M,3) = logdata.Decoder(idx3);

    % Create array with BER values for each LDPC iteration
    ber(1:M,1) = logdata.BER(idx1);
    ber(1:M,2) = logdata.BER(idx2);
    ber(1:M,3) = logdata.BER(idx3);
    
    % Create array with xaxis labels
    x_labels(idx1) = "QAM" + logdata.Modulation(idx1);
    x_labels = rmmissing(x_labels);
    
    figure;

    % Create axes
    colororder([0 0 0]);

    yyaxis right;
    b = bar(y);
    b(1).FaceColor = navy_blue;
    b(2).FaceColor = steel_blue;
    b(3).FaceColor = powder_blue;
    ylabel("Execution time [ms]");
%     ylim([0 2500]);
    
    yyaxis left;
    x_ber = 1:1:M;
    semilogy(x_ber, ber(:,1) + 0.0001, "-^", "MarkerSize", 7, "MarkerFaceColor", dark_red, "Color", dark_red);
    hold on;
    semilogy(x_ber, ber(:,2) + 0.0001, ":^", "MarkerSize", 7, "MarkerFaceColor", dark_red, "Color", dark_red);
    semilogy(x_ber, ber(:,3) + 0.0001, "-.^", "MarkerSize", 7, "MarkerFaceColor", dark_red, "Color", dark_red);
    hold off;
    axis padded;
    ylabel("Bit Error Rate (BER)");

    % Add x axis labels
    xticklabels(x_labels);
    
    % Misc plot settings
    title("LDPC Decoder Iterations (Eb/N0=" + noise + "dB, 8 Blocks)");
    grid on;
    xlabel("Modulation type");

    legend("BER (" + iter1 + " Iterations)", "BER (" + iter2 + " Iterations)", "BER (" + iter3 + " Iterations)", ...
           "LDPC " + iter1 + " Iterations", "LDPC " + iter2 + " Iterations", "LDPC " + iter3 + " Iterations",...
        "Location", "southoutside", "NumColumns", 2, "FontSize", 8);
    %            "Location", "northwest");
           

    set(gca, "SortMethod", "Depth");
    set(gcf, "renderer", "Painters");
%     saveas(gcf, "plots/ldpc_plot_" + path + "_EbN0dB_" + noise, "epsc");
    saveas(gcf, "plots/ldpc_plot_EbN0dB_" + noise, "epsc");

    save("data");
end