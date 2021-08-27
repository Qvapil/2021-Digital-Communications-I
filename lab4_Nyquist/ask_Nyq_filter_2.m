function errors=ask_Nyq_filter_2(k,Nsymb,nsamp,EbNo,rolloff,delay)
L=2^k; step=2;
% Διάνυσμα τυχαίων bits
x=randi([0,1],1,Nsymb*k); 

mapping=[step/2; -step/2];
if(k>1)
 for j=2:k
 mapping=[mapping+2^(j-1)*step/2; ...
 -mapping-2^(j-1)*step/2];
 end
end;
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb');
y1=[];
for i=1:length(xsym)
 y1=[y1 mapping(xsym(i)+1)];
end

%% Ορισμός παραμέτρων φίλτρου
filtorder = delay*nsamp*2; % τάξη φίλτρου
% κρουστική απόκριση φίλτρου τετρ. ρίζας ανυψ. συνημιτόνου
rNyquist= rcosine(1,nsamp,'fir/sqrt',rolloff,delay);
% ----------------------
%% ΕΚΠΕΜΠΟΜΕΝΟ ΣΗΜΑ
% Υπερδειγμάτιση και εφαρμογή φίλτρου rNyquist
y=upsample(y1,nsamp);
ytx = conv(y,rNyquist); 
% Διάγραμμα οφθαλμού για μέρος του φιλτραρισμένου σήματος
% eyediagram(ytx(1:2000),nsamp*2);

SNR=EbNo-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος
Py=10*log10(ytx*ytx'/length(ytx));
Pn=Py-SNR;
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
ynoisy=ytx+n;
%ynoisy=awgn(ytx,SNR,'measured'); % θορυβώδες σήμα
% ----------------------
%% ΛΑΜΒΑΝΟΜΕΝΟ ΣΗΜΑ
% Φιλτράρισμα σήματος με φίλτρο τετρ. ρίζας ανυψ. συνημ.
yrx=conv(ynoisy,rNyquist);
yrx = yrx(2*nsamp*delay+1:end-2*nsamp*delay); % περικοπή, λόγω καθυστέρησης
yr = downsample(yrx,nsamp); % Υποδειγμάτιση

% Ανιχνευτής ελάχιστης απόστασης L πλατών
xr=[];
for i=1:length(yr)
    [m,j]=min(abs(mapping-yr(i)));
    xr=[xr de2bi(j-1,k,'left-msb')];
end
errors=sum(not(x==xr));