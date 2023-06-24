% Function to generate demodulator bar graph with LLR Mean relative erro
function demod_time( ...
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
    base = y(1,1);

    % S2.14 Base MUL16
    y(2,1) = mean(logdata_fxp_base16.Demod_Opt(idx_fxp_base16));

    % S2.14 Approx MUL16
    y(3,1) = mean(logdata_fxp_approx16.Demod_Opt(idx_fxp_approx16));

    % S2.14 Base MUL32
    y(4,1) = mean(logdata_fxp_base32.Demod_Opt(idx_fxp_base32));

    % S2.14 Approx MUL32
    y(5,1) = mean(logdata_fxp_approx32.Demod_Opt(idx_fxp_approx32));

    % S2.6 Base MUL16
    y(6,1) = mean(logdata_fxp8_base16.Demod_Opt(idx_fxp8_base16));

    % S2.6 Approx MUL16
    y(7,1) = mean(logdata_fxp8_approx16.Demod_Opt(idx_fxp8_approx16));
        
    % S2.6 Base MUL32
    y(8,1) = mean(logdata_fxp8_base32.Demod_Opt(idx_fxp8_base32));

    % S2.6 Approx MUL32
    y(9,1) = mean(logdata_fxp8_approx32.Demod_Opt(idx_fxp8_approx32));

    % Calculate speedup
    for i=2:9
        speedup(i) = round(base/y(i,1), 2);
    end

    % Bar graph
    figure;
%     colororder([0 0 0]);
%     x = ["FLP Base" "FXP S2.14 Base" "FXP S2.14 Approx"]; 

    b = bar(y, "stacked", "BarWidth", 0.4, "EdgeColor", "none");
    
%     xticklabels({});

    x_labels = ["FLP-BASE", ...
        "S2.14-BASE16", "S2.14-APRX16", "S2.14-BASE32", "S2.14-APRX32", ...
        "S2.6-BASE16", "S2.6-APRX16", "S2.6-BASE32", "S2.6-APRX32"];
    set(gca, "XTickLabel", x_labels);

    b(1).FaceColor = navy_blue;
%     b(2).FaceColor = steel_blue;
    
%     b(3).FaceColor = powder_blue;
%     b(4).FaceColor = sky_blue;
%     b(5).FaceColor = royal_blue; 
    
    ylabel("Execution Time [ms]");
    xlabel("Demodulator Implementation");

    % Add speedup for fxp16
    xtips1 = b(1).XEndPoints;
    ytips1 = b(1).YEndPoints;
    labels1 = string("$\times$" + speedup);
    labels1(1) = " ";
    text(xtips1, ytips1, labels1, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 8, "Rotation", 45)

%     yline(100,'--r','Threshold');
%     yline(y(2,1)+y(2,2),'--r','S2.14-BASE16', "Interpreter", "latex");

%     yline(y(2,1)+y(2,2),'--r');

    % Misc plot settings
    title("Demodulator - QAM64 (N = 64800)");
%     grid on;

    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'on';

%     xlabel("Modulation type");
    legend("Demodulator",...
        "Location", "northeast");

    set(gca, 'TickLabelInterpreter','latex');

    saveas(gca, "plots/demod_qam64", "epsc");
    save("data");
end