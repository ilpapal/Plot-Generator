% Function to generate demodulator bar graph with LLR Mean relative erro
function demod_time_qam16( ...
    logdata_fxp_base16, logdata_fxp_approx16,...
    logdata_fxp_base32, logdata_fxp_approx32)

    % Load colors from colors.m
    run("colors.m");
    
    % Use LaTeX for plots
    set(0, 'defaultTextInterpreter','latex');
    set(0, 'defaultLegendInterpreter', 'latex');

    % Extract data from table for specific noise and LDPC iterations
    idx_fxp_base16 = find(logdata_fxp_base16.LDPC_Iter == 0);
    idx_fxp_approx16 = find(logdata_fxp_approx16.LDPC_Iter == 0);

    idx_fxp_base32 = find(logdata_fxp_base32.LDPC_Iter == 0);
    idx_fxp_approx32 = find(logdata_fxp_base32.LDPC_Iter == 0);

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

    % Calculate speedup
    for i=2:5
        speedup(i) = round(base/y(i,1), 2);
    end

    % Bar graph
    figure;
%     colororder([0 0 0]);
%     x = ["FLP Base" "FXP S2.14 Base" "FXP S2.14 Approx"]; 

    b = bar(y, "stacked", "BarWidth", 0.4, "EdgeColor", "none");
    
%     xticklabels({});

    x_labels = ["FLP64-B64", ...
        "FXP16-B16", "FXP16-A16", "FXP16-B32", "FXP16-A32"];
    set(gca, "XTickLabel", x_labels);

    % b(1).FaceColor = navy_blue;
    b(1).FaceColor = blue80;
    
    ylabel("Execution Time [ms]");
    xlabel("Demodulator Implementation");

    % Add speedup for fxp16
    xtips1 = b(1).XEndPoints;
    ytips1 = b(1).YEndPoints;
    labels1 = string("$\times$" + speedup);
    labels1(1) = " ";
    text(xtips1, ytips1, labels1, "HorizontalAlignment", "left",...
        "VerticalAlignment", "bottom", "FontSize", 7, "Rotation", 45)

    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'on';

%     xlabel("Modulation type");
    legend("Demodulator",...
        "Location", "northeast");

    % Set vertical lines for seperating implementations
    xline(1.5, '--', 'HandleVisibility','off');

    set(gca, 'TickLabelInterpreter','latex');
    set(gcf, 'Position', [10, 10, 510, 290]);

    set(gca, 'TickLabelInterpreter','latex');

    % saveas(gca, "plots/demod_qam64", "epsc");
    system("rm -y plots/demod_qam16.pdf");
    saveas(gcf, "plots/demod_qam16.pdf");
    system("pdfcrop plots/demod_qam16.pdf plots/demod_qam16.pdf");
    % save("data");
end