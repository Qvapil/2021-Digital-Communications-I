%% Input parameters
% bps: bits per symbol, Nsymb: numb of simulated symbols
% ns: number of samples per symbol (oversampling)
% EbNo: normalized signal-to-noise ratio, in db
clear all; close all; clc;
bps=5; Nsymb=2000; ns=256; EbNo=6;
M=2^bps; % number of different symbols
BR=1; % Baud Rate
fc=2*M*BR; % RF frequency
%% Derived parameters
nb=bps*Nsymb; % number of simulated data bits
T=1/BR; % one symbol period 
Ts=T/ns; % oversampling period
% M frequencies in "coherent" distance (BR)
fcoh=fc+BR/2*((1:M)-(M+1)/2); 
% M frequencies in "non-coherent" distance (BR) 
fnon=fc+BR*((1:M)-(M+1)/2); 
% input data bits
y=randi([0,1],1,nb); % 
x=reshape(y,bps,length(y)/bps)';
t=[0:T:length(x(:,1))*T]'; % time vector on the T grid
tks=[0:Ts:T-Ts]';
%% FSK signal
%non coherent
s=[];
A=sqrt(2/T/ns);
for k=1:length(x(:,1))
 fk=fnon(bi2de(x(k,:))+1);
 tk=(k-1)*T+tks;
 s=[s; sin(2*pi*fk*tk)];
end
figure(1); pwelch(s,[],[],[],ns);

%coherent
s=[];
A=sqrt(2/T/ns);
for k=1:length(x(:,1))
 fk=fcoh(bi2de(x(k,:))+1);
 tk=(k-1)*T+tks;
 s=[s; sin(2*pi*fk*tk)];
end
figure(2); pwelch(s,[],[],[],ns);