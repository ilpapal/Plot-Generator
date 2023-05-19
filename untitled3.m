% Calculate theoretical BER values for given modulation and AWGN Channel
EbN0 = [0 5 10 14 20];
BER_theor = berawgn(EbN0, 'qam', 16);

% Use polyfit for each BER data
EbN0_p = linspace(0, 20);
p = polyfit(EbN0, BER_theor + eps, 8);
f = polyval(p, EbN0_p);

fitber = berfit(EbN0, BER_theor, EbN0_p);
berfit(EbN0, BER_theor + eps, EbN0_p, fittype, "exp");

%%
% Plot theoretical BER relative to Eb/N0
figure;
semilogy(EbN0_p, fitber,...
    "--",...
    "DisplayName", "Theoretical BER");
hold on;
semilogy(EbN0, BER_theor, "^");
% hold on;