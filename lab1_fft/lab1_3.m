%library for octave
pkg load signal


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 : Create the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all 
clear all  
clc  
Fs=2000;  
Ts=1/Fs;
L=2000;
T=L*Ts;
t=0:Ts:(L-1)*Ts;

x=sin(2*pi*100*t)+0.3*sin(2*pi*150*(t-2))+sin(2*pi*200*t);

% Plot signal in time domain

figure(1)
plot(t,x) 
title("Time domain plot of x")
xlabel('t (sec)')
ylabel('Amplitude')   
axis([0 0.3 -2 2])

% Compute DFT

N = 2^nextpow2(L);
Fo=Fs/N;
f=(0:N-1)*Fo;
X=fft(x,N);

% Plot the signal in frequency domain

figure(2)
plot(f(1:(N-1)/2),abs(X(1:(N-1)/2)))
title("Frequency domain plot of x")
xlabel('f (Hz)')
ylabel('Amplitude')

% Shift to center of spectrum with fftshift

figure(3)
f=f-Fs/2;
X=fftshift(X);
plot(f,abs(X));title("Two sided spectrum of x"); xlabel('f (Hz)'); 
ylabel('Amplitude')

% Compute power
power=X.*conj(X)/N/L;
figure(4)
plot(f,power)
xlabel('Frequency (Hz)')
ylabel('Power')
title("Periodogram")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 : Add noise to the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Part2')

%Plot noise in time domain
n=randn(size(x));
figure(5)
plot(t,n) 
title("Time domain plot of noise")
xlabel('t (sec)')
ylabel('Amplitude')            
axis([0 0.3 -2 2])       

%Power spectral density of noise
noise_power=fftshift(fft(n,N)).*conj(fftshift(fft(n,N)))/N/L;
figure(6)
plot(f,noise_power)
xlabel('Frequency (Hz)')
ylabel('Power')
title("Periodogram of noise")

%Plot noisy signal in time domain
s=x+n;
figure(7)
plot(t,s) 
title("Time domain plot of noisy signal s")
xlabel('t (sec)')
ylabel('Amplitude')        
axis([0 0.3 -2 2])

%Plot s in frequency domain
S=fftshift(fft(s,N));
figure(8)
plot(f,abs(S));title("Two sided spectrum of s"); xlabel('f (Hz)'); 
ylabel('Amplitude')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 3 : signal multiplication
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Part3')
s3=sin(2*pi*700*t).*s;
figure(9)
plot(t,s3) 
title("Time domain plot of noisy signal s3")
xlabel('t (sec)')
ylabel('Amplitude')           
axis([0 0.3 -2 2])

S3=fftshift(fft(s3,N));
figure(10)
plot(f,abs(S3));title("Two sided spectrum of s3"); xlabel('f (Hz)'); 
ylabel('Amplitude')


     