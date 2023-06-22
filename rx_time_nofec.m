% Function to generate demodulator bar graph with LLR Mean relative erro
function rx_time_nofec( ...
    logdata_fxp_base16, logdata_fxp_approx16,...
    logdata_fxp_base32, logdata_fxp_approx32,...
    logdata_fxp8_base16, logdata_fxp8_approx16,...
    logdata_fxp8_base32, logdata_fxp8_approx32...
    )

    % Load colors from colors.m
    run("colors.m");
    
    % Use LaTeX for plots
    set(0, 'defaultTextInterpreter','latex');
    set(0, 'defaultLegendInterpreter', 'latex');

    % Extract data from table for specific noise and LDPC iterations
    % idx_fxp_base16 = find(logdata_fxp_base16.EbN0dB == noise & logdata_fxp_base16.LDPC_Iter == 0);
    idx_fxp_base16 = find(logdata_fxp_base16.LDPC_Iter == 0);
    idx_fxp_approx16 = find(logdata_fxp_approx16.LDPC_Iter == 0);

    idx_fxp_base32 = find(logdata_fxp_base32.LDPC_Iter == 0);
    idx_fxp_approx32 = find(logdata_fxp_base32.LDPC_Iter == 0);

    idx_fxp8_base16 = find(logdata_fxp8_base16.LDPC_Iter == 0);
    idx_fxp8_approx16 = find(logdata_fxp8_approx16.LDPC_Iter == 0);

    idx_fxp8_base32 = find(logdata_fxp8_base32.LDPC_Iter == 0);
    idx_fxp8_approx32 = find(logdata_fxp8_approx32.LDPC_Iter == 0);

    % Create array with base and optimized time values
    % FLP Base
    y(1,1) = mean(logdata_fxp_base16.Demod_Base(idx_fxp_base16));
    y(1,2) = mean(logdata_fxp_base16.Deinterleaver(idx_fxp_base16));
    base = y(1,1) + y(1,2);

    % S2.14 Base MUL16
    y(2,1) = mean(logdata_fxp_base16.Demod_Opt(idx_fxp_base16));
    y(2,2) = mean(logdata_fxp_base16.Deinterleaver(idx_fxp_base16));

    % S2.14 Approx MUL16
    y(3,1) = mean(logdata_fxp_approx16.Demod_Opt(idx_fxp_approx16));
    y(3,2) = mean(logdata_fxp_approx16.Deinterleaver(idx_fxp_approx16));

    % S2.14 Base MUL32
    y(4,1) = mean(logdata_fxp_base32.Demod_Opt(idx_fxp_base32));
    y(4,2) = mean(logdata_fxp_base32.Deinterleaver(idx_fxp_base32));

    % S2.14 Approx MUL32
    y(5,1) = mean(logdata_fxp_approx32.Demod_Opt(idx_fxp_approx32));
    y(5,2) = mean(logdata_fxp_approx32.Deinterleaver(idx_fxp_approx32));

    % S2.6 Base MUL16
    y(6,1) = mean(logdata_fxp8_base16.Demod_Opt(idx_fxp8_base16));
    y(6,2) = mean(logdata_fxp8_base16.Deinterleaver(idx_fxp8_base16));

    % S2.6 Approx MUL16
    y(7,1) = mean(logdata_fxp8_base16.Demod_Opt(idx_fxp8_approx16));
    y(7,2) = mean(logdata_fxp8_base16.Deinterleaver(idx_fxp8_approx16));
        
    % S2.6 Base MUL32
    y(8,1) = mean(logdata_fxp8_base16.Demod_Opt(idx_fxp8_base32));
    y(8,2) = mean(logdata_fxp8_base16.Deinterleaver(idx_fxp8_base32));

    % S2.6 Approx MUL32
    y(9,1) = mean(logdata_fxp8_base16.Demod_Opt(idx_fxp8_approx32));
    y(9,2) = mean(logdata_fxp8_base16.Deinterleaver(idx_fxp8_approx32));


    % Calculate speedup
    for i=2:9
        speedup(i) = round(base/(y(i,1) + y(i,2)), 2);
    end

    % Bar graph
    figure;
%     colororder([0 0 0]);
%     x = ["FLP Base" "FXP S2.14 Base" "FXP S2.14 Approx"]; 

    b = bar(y, "stacked", "BarWidth", 0.38);
    
%     xticklabels({});

    x_labels = ["FLP-BASE", ...
        "S2.14-BASE16", "S2.14-APRX16", "S2.14-BASE32", "S2.14-APRX32", ...
        "S2.6-BASE16", "S2.6-APRX16", "S2.6-BASE32", "S2.6-APRX32"];
    set(gca, "XTickLabel", x_labels);

    b(1).FaceColor = navy_blue;
    b(2).FaceColor = steel_blue;
    
%     b(3).FaceColor = powder_blue;
%     b(4).FaceColor = sky_blue;
%     b(5).FaceColor = royal_blue; 
    
    ylabel("Execution Time [ms]");
    xlabel("Demodulator Implementation");

    % Add speedup for fxp16
    xtips1 = b(2).XEndPoints;
    ytips1 = b(2).YEndPoints;
    labels1 = string("$\times$" + speedup);
    labels1(1) = " ";
    text(xtips1, ytips1, labels1, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 9, "Rotation", 45)

    % Misc plot settings
    title("Receiver without FEC - QAM64 (N = 64800)");
    grid on;
%     xlabel("Modulation type");
    legend("Demodulator", "De-interleaver",...
        "Location", "northeast");

    set(gca, 'TickLabelInterpreter','latex');

    saveas(gca, "plots/rx_qam64", "epsc");
    save("data");
end