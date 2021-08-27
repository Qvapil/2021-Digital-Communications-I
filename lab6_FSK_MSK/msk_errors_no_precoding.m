function errors=msk_errors_no_precoding(Nbits,nsamp,EbNo)
% Οριζόμενες παράμετροι
% Nbits=2000; nsamp=16; EbNo=10;
n=Nbits; % αριθμός data bits
R=3*10^6; % bit rate
fc=10/3*R; % φέρουσα συχνότητα 
ns=nsamp; % παράγοντας υπερδειγμάτισης
%
% δίαυλος awgn
SNR=EbNo-10*log10(ns/2); % in db
% Παραγόμενες παράμετροι
T=1/R; % περίοδος 1 bit (= βασική περίοδος)
Ts=T/ns; % συχνότητα δειγματοληψίας
% ακολουθία εισόδου
y=[1;sign(rand(n-1,1)-0.5)]; % random numbers, -1 ή 1
%
% προκωδικοποίηση
x(1)=1;
for i=2:length(y)
 x(i)=y(i)*y(i-1);
end
x=x';
g=ones(ns,1);
xx=conv(upsample(x,ns),g); % δείγματα παλμοσειράς NRZ polar 
% χρονικό πλέγμα
ts=[0:Ts:length(xx)*Ts]'; % μήκους ns*(n+1) 
%
%% ΠΟΜΠΟΣ MSK 
xs=xx;
theta=cumsum(xs)*pi/2/ns;
xs_i=cos(theta); % συμφασική συνιστώσα
xs_i=[xs_i; xs_i(length(xs_i))]; % επέκταση με ένα ακόμη δείγμα
xs_q=sin(theta); % εγκάρσια συνιστώσα
xs_q=[xs_q; xs_q(length(xs_q))]; % επέκταση με ένα ακόμη δείγμα
% Διαμόρφωση
s=xs_i.*cos(2*pi*fc*ts)-xs_q.*sin(2*pi*fc*ts);
% προσθήκη θορύβου
s=awgn(s,SNR, 'measured');
%% ΔΕΚΤΗΣ MSK 
xs_i=s.*cos(2*pi*fc*ts);
xs_q=-s.*sin(2*pi*fc*ts);
% Φίλτρο LP (Parks-McClellan) 
f1=0.75/ns; f2=4*f1;
order=4*ns;
fpts=[0 f1 f2 1];
mag=[1 1 0 0];
wt=[1 1];
b = firpm(order,fpts,mag,wt);
a=1;
len=length(xs_i);
dummy=[xs_i;zeros(order,1)];
dummy1=filter(b,a,dummy);
delay=order/2; % Δοκιμάστε με delay=0!
xs_i=dummy1(delay+(1:len));
dummy=[xs_q;zeros(order,1)];
dummy1=filter(b,a,dummy);
delay=order/2;
xs_q=dummy1(delay+(1:len)); 
bi=1; xr_1=1; 
for k=1:2:n-1
 li=(k*ns+1:(k+2)*ns)';
 lq=((k-1)*ns+1:(k+1)*ns)';
 xi=xs_i(li);
 xq=xs_q(lq);
 gmi=cos(pi/2/T*Ts*li); % παλμός matched-filter
 gmq=-gmi; % =sin(pi/2/T*Ts*lq);
 bi_1=bi;
 bi=sign(sum(xi.*gmi));
 bq=sign(sum(xq.*gmq));
 % χωρίς προκωδικοποίηση
 xr(k)=bi_1*bq;
 xr(k+1)=bi*bq;
end
xr=xr';
err=not(x==xr);
errors=sum(err);
end