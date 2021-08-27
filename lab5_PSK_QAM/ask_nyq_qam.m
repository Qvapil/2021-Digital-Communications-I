function errors=ask_nyq_qam(M,Nsymb,nsamp,EbNo,rolloff)
% M=16; Nsymb=2000%; nsamp=16; EbNo=12; rolloff=0.33;
L=sqrt(M); l=log2(L); k=log2(M);

%% Grey encoding vector
core=[1+1j;1-1j;-1+1j;-1-1j]; 
mapping=core;
if(l>1)
 for j=1:l-1
 mapping=mapping+j*2*core(1);
 mapping=[mapping;conj(mapping)];
 mapping=[mapping;-conj(mapping)];
 end
end;

%% Random bits -> symbols
x=floor(2*rand(k*Nsymb,1));
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb')';
y=[];
for i=1:length(xsym)
 y=[y mapping(xsym(i)+1)];
end

%% Filter parametres
delay=8;
filtorder = delay*nsamp*2;
rNyquist= rcosine(1,nsamp,'fir/sqrt',rolloff,delay);

%% Transmitter
ytx=upsample(y,nsamp);
ytx = conv(ytx,rNyquist);
R=6000000;
Fs=R/k*nsamp;
fc=4;  %carrier frequency / baud rate
m=(1:length(ytx));
s=real(ytx.*exp(1j*2*pi*fc*m/nsamp));  % shift to desired frequency band
% figure(1); pwelch(s,[],[],[],Fs); % COMMENT FOR BERTOOL

%% Noise
SNR=EbNo-10*log10(nsamp/2/k);
Ps=10*log10(s*s'/length(s)); %signal power (db)
Pn=Ps-SNR; %noise power (db)
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
snoisy=s+n;
clear ytx xsym s n;

%% Receiver
yrx=2*snoisy.*exp(-1j*2*pi*fc*m/nsamp); clear s; %shift to 0 frequency
yrx = conv(yrx,rNyquist); %filter
yrx = yrx(2*nsamp*delay+1:end-2*nsamp*delay);
% figure(2); pwelch(real(yrx),[],[],[],Fs); % COMMENT FOR BERTOOL
yrx = downsample(yrx,nsamp); 

%% Error counting
yi=real(yrx); yq=imag(yrx); 
xrx=[]; 
q=[-L+1:2:L-1];
for n=1:length(yrx) 
    [m,j]=min(abs(q-yi(n)));
    yi(n)=q(j);
    [m,j]=min(abs(q-yq(n)));
    yq(n)=q(j);
end
errors=sum(not(y==(yi+1j*yq)));
