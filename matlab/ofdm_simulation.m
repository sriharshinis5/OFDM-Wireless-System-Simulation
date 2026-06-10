clc;
clear;
close all;

N = 64;
cp = 16;

snr_db = 0:2:20;

ber = zeros(size(snr_db));

for k = 1:length(snr_db)

    data = randi([0 1],10000,1);

    modData = pskmod(data,2);

    tx_ofdm = ifft(modData,N);

    tx_cp = [tx_ofdm(end-cp+1:end); tx_ofdm];

    rx = awgn(tx_cp,snr_db(k),'measured');

    rx = rx(cp+1:end);

    rx_fft = fft(rx,N);

    demodData = pskdemod(rx_fft,2);

    [~,ber(k)] = biterr(data,demodData);
end

figure;
semilogy(snr_db,ber,'-o');
grid on;

xlabel('SNR (dB)');
ylabel('BER');

title('BER vs SNR for OFDM System');
