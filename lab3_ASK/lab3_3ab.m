clear all; close all; clc;
k=4; M=30000; d=3; nsamp=16; EbNo=15; L=2^k;

%theoretical BER
EbNo=0:18;
BERtheor=(L-1)/L*erfc(sqrt(3*k/(L^2-1).*10.^(EbNo/10)))/k;
figure(1)
semilogy(EbNo,BERtheor);
grid on;
title("BER of 8-ASK");
xlabel("Eb/N0"); ylabel("BER");
hold on;

%simulation
BER=zeros(1,18);
for n=0:17
    BER(n+1)=ask_errors_3_orthogonal(k,M,nsamp,n,d)/M/k;
end
plot(0:17,BER,'*')
legend("theoretical","simulated")
hold off;

%3b
% Διάνυσμα τυχαίων ακεραίων {±1, ±3, ... ±(L-1)}*d/2
x=(2*floor(L*rand(1,M))-L+1)*d/2;
A=[-L+1:2:L-1]*d/2;
figure(2)
stem(x(1:20)); title("x");

h=ones(1,nsamp); % κρουστική απόκριση φίλτρου πομπού 
h=h/sqrt(h*h');  % (ορθογωνικός παλμός μοναδιαίας ενέργειας)
y=upsample(x,nsamp); % μετατροπή στο πυκνό πλέγμα
y=conv(y,h); % το προς εκπομπή σήμα
y=y(1:M*nsamp); % περικόπτεται η ουρά που αφήνει η συνέλιξη
figure(3)
stem(y(1:20*nsamp)); title("y");
ynoisy=y; % θεωρώ μηδενικό θόρυβο
for i=1:nsamp matched(i)=h(end-i+1); end
yrx=conv(ynoisy,matched); 
figure(4)
stem(yrx(1:20*nsamp)); title("yrx");