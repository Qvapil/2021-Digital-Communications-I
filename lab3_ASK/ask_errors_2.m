function errors=ask_errors_2(k,M,nsamp,EbNo,d)
% Η συνάρτηση αυτή εξομοιώνει την παραγωγή και αποκωδικοποίηση 
% θορυβώδους σήματος L-ASK και μετρά τον αριθμό των εσφαλμένων συμβόλων.
% Επιστρέφει τον αριθμό των εσφαλμένων συμβόλων (στη μεταβλητή errors). 
% k είναι ο αριθμός των bits/σύμβολο, επομένως L=2^k -- ο αριθμός των
% διαφορετικών πλατών
% M είναι ο αριθμός των παραγόμενων συμβόλων (μήκος ακολουθίας L-ASK)
% nsamp ο αριθμός των δειγμάτων ανά σύμβολο (oversampling ratio)
% EbNo είναι ο ανηγμένος σηματοθορυβικός λόγος Eb/No, σε db
% 
L=2^k;
SNR=EbNo-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος
% Διάνυσμα τυχαίων ακεραίων {±1, ±3, ... ±(L-1)}*d/2
x=(2*floor(L*rand(1,M))-L+1)*d/2; 
Px=(L^2-1)/3*(d^2)/4; % θεωρητική ισχύς σήματος
sum(x.^2)/length(x); % μετρούμενη ισχύς σήματος (για επαλήθευση)
y=rectpulse(x,nsamp);
n=wgn(1,length(y),10*log10(Px)-SNR);
ynoisy=y+n; % θορυβώδες σήμα
y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
matched=ones(1,nsamp);
z=matched*y/nsamp;
A=[-L+1:2:L-1]*d/2;
for i=1:length(z)
    [m,j]=min(abs(A-z(i)));
    z(i)=A(j);
end
err=not(x==z);
errors=sum(err);
end