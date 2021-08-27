clear all; close all; clc;
k=4; M=30000; d=3; nsamp=16; EbNo=[12 14 18];

L=2^k;
SNR=EbNo-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος
% Διάνυσμα τυχαίων ακεραίων {±1, ±3, ... ±(L-1)}*d/2
x=(2*floor(L*rand(1,M))-L+1)*d/2;
A=[-L+1:2:L-1]*d/2;
figure(1);
hist(x,A); title("Histogram of x");
disp('Theoretical power of x:')
Px=(L^2-1)/3*(d^2)/4 % θεωρητική ισχύς σήματος
disp('Simulated power of x:');
sum(x.^2)/length(x) % μετρούμενη ισχύς σήματος (για επαλήθευση)
y=rectpulse(x,nsamp);
matched=ones(1,nsamp);

n12=wgn(1,length(y),10*log10(Px)-SNR(1));
ynoisy12=y+n12; % θορυβώδες σήμα με EbNo=12
y12=reshape(ynoisy12,nsamp,length(ynoisy12)/nsamp);
z12=matched*y12/nsamp;
figure(2);
hist(z12,200); title("Histogram of z for EbNo=12");

n14=wgn(1,length(y),10*log10(Px)-SNR(2));
ynoisy14=y+n14; % θορυβώδες σήμα με EbNo=14
y14=reshape(ynoisy14,nsamp,length(ynoisy14)/nsamp);
z14=matched*y14/nsamp;
figure(3);
hist(z14,200); title("Histogram of z for EbNo=14");

n18=wgn(1,length(y),10*log10(Px)-SNR(3));
ynoisy18=y+n18; % θορυβώδες σήμα με EbNo=18
y18=reshape(ynoisy18,nsamp,length(ynoisy18)/nsamp);
z18=matched*y18/nsamp;
figure(4);
hist(z18,200); title("Histogram of z for EbNo=18");
