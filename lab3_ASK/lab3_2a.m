clear all; close all; clc;
k=4; nsamp=16; M=20000; L=2^k; d=3;  %k=3

%theoretical BER
EbNo=0:18;
BERtheor=(L-1)/L*erfc(sqrt(3*k/(L^2-1).*10.^(EbNo/10)))/k;
figure()
semilogy(EbNo,BERtheor);
grid on;
title("BER of 8-ASK");
xlabel("Eb/N0"); ylabel("BER");
hold on;

%simulation
BER=zeros(1,18);
for n=0:17
    BER(n+1)=ask_errors_2(k,M,nsamp,n,d)/M/k;
end
plot(0:17,BER,'*')
legend("theoretical","simulated")