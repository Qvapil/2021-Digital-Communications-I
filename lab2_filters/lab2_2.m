clear all; close all;
% File sima.mat has the signal s
% and sampling frequency Fs.
% The spectrum reaches frequencies up to 4kHz
% but everything above 1kHz is noise and must be filtered out.
load sima; 
figure; pwelch(s,[],[],[],Fs); legend('Signal s');
% Ideal band pass function H with band 1500kHz-3000kHz
H=[zeros(1,1500) ones(1,1500) zeros(1,2192) ones(1,1500) zeros(1,1500)];
% Impulse response with inverse Fourier transform
% Alternatively, the analytic function Sa(x) can be used
h=ifft(H,'symmetric');
middle=length(h)/2;
h=[h(middle+1:end) h(1:middle)];
h32=h(middle+1-16:middle+17);
h64=h(middle+1-32:middle+33);
h128=h(middle+1-64:middle+65);
% figure; stem([0:length(h64)-1],h64); grid;
% figure; freqz(h64,1); % frequency response of h64
wvtool(h32,h64,h128); % frequency responses of cut h
% side peaks are high!
% Multiply the cut impulse response with windows
% We use h64 with hamming and kaiser windows
wh=hamming(length(h64));
wk=kaiser(length(h64),5);
figure; plot(0:64,wk,'r',0:64,wh,'b'); grid; legend('Kaiser','Hamming');
h_hamming=h64.*wh';
% figure; stem([0:length(h64)-1],h_hamming); grid;
% figure; freqz(h_hamming,1);
h_kaiser=h64.*wk';
wvtool(h64,h_hamming,h_kaiser);
% Filter the signal with each filter
y_rect=conv(s,h64);
figure; pwelch(y_rect,[],[],[],Fs); legend('h64 filter');
y_hamm=conv(s,h_hamming);
figure; pwelch(y_hamm,[],[],[],Fs); legend('Hamming filter');
y_kais=conv(s,h_kaiser);
figure; pwelch(y_kais,[],[],[],Fs); legend('Kaiser filter');
%
% Low pass Parks-MacClellan
f1=1500; f2=3000;
f=2*[0 f1*0.96 f1*1.04 f2*0.98 f2*1.02 Fs/2]/Fs;
hpm=firpm(128, f, [0 0 1 1 0 0]);
figure; freqz(hpm,1); legend('Parks-MacClellan');
s_pm=conv(s,hpm);
figure; pwelch(s_pm,[],[],[],Fs); legend('Parks-MacClellan');
sound(20*s); % listen to the initial signal s
%sound(20*s_lp); % listen to the filtered signal s_lp
%sound(20*s_pm);