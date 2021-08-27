function errors=ask_nyq_psk_34(k,Nsymb,nsamp,EbNo,rolloff,R)
% k=3; Nsymb=2000%; nsamp=16; EbNo=14; rolloff=0.33; R=4500000;
L=2^k;

%% Grey encoding vector
ph1=[pi/4]; 
theta=[ph1; -ph1; pi-ph1; -pi+ph1];
mapping=exp(1j*theta);
if(k>2)
 for j=3:k
 theta=theta/2;
 mapping=exp(1j*theta);
 mapping=[mapping; -conj(mapping)];
 theta=log(mapping)/1j;
 end
end

%% Random bits -> symbols
x=floor(2*rand(k*Nsymb,1)); 
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb')';
y1=[];
for i=1:length(xsym)
 y1=[y1 mapping(xsym(i)+1)];
end

%% Filter parametres
delay=8;
filtorder = delay*nsamp*2;
rNyquist= rcosine(1,nsamp,'fir/sqrt',rolloff,delay);

%% Transmitter
y=upsample(y1,nsamp);
ytx = conv(y,rNyquist);
Fs=R/k*nsamp;
fc=4;  %carrier frequency / baud rate
m=(1:length(ytx));
s=real(ytx.*exp(1j*2*pi*fc*m/nsamp));  % shift to desired frequency band
figure(1); pwelch(s,[],[],[],Fs); % COMMENT FOR BERTOOL

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
figure(2); pwelch(real(yrx),[],[],[],Fs); % COMMENT FOR BERTOOL
yr = downsample(yrx,nsamp); 

%% Error counting
xr=[];
q=[0:1:L-1];
for n=1:length(yr)
 [m,j]=min(abs(theta-angle(yr(n))));    % compare angle to theta
 yr(n)=q(j);
 xr=[xr; de2bi(q(j),k,'left-msb')'];
end
errors=sum(not(x==xr));
