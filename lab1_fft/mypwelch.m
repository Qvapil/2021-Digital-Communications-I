function mypwelch(s,Fs)
  L=length(s);
  w=max(2^nextpow2(L/8),256);
  overlap=0.5;
  num=floor(L/(w*overlap));
  
  Pxx_sum=zeros(1,w);
  for i=1:num-1
    if i==1
      block=[zeros(1,w*(1-overlap)) s(1:w*overlap)];
    else
      block=s((1:w)+(i-2)*w*overlap);
    endif
    blockf=fft(block);
    power=abs(blockf).^2;
    power=10*log10(power);
    Pxx=(power.*conj(power))/w;
    Pxx_sum=Pxx_sum+Pxx;
  endfor
  psd_avg=Pxx_sum/num;
  psd_avg_2=psd_avg(1:w/2+1)+[0,psd_avg(w:-1:w/2+2),0];

  plot(0:0.5/length(psd_avg_2):0.5-0.5/length(psd_avg_2),psd_avg_2)
endfunction
