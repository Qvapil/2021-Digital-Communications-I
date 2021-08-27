function psk_scatterplot(k)
% k is the number of bits per symbol
M=2^k;
ph1=[pi/4]; 
theta=[ph1; -ph1; pi-ph1; -pi+ph1];
mapping=exp(1j*theta);
if(k>2)
 for j=3:k
 theta=theta/2;
 mapping=exp(1j*theta);
 mapping=[mapping; -conj(mapping)];
 theta=angle(mapping);
 end
end
scatterplot(mapping);
text(real(mapping),imag(mapping),num2str(de2bi([0:M-1].',k,'left-msb')), 'FontSize', 6);
end