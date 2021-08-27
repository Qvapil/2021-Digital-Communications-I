function [ber,numBits] = ask_ber_func_fsk_noncoherent(EbNo, maxNumErrs, maxNumBits)
% Import Java class for BERTool.
import com.mathworks.toolbox.comm.BERTool;
% Initialize variables related to exit criteria.
totErr = 0; % Number of errors observed
numBits = 0; % Number of bits processed
% Α. --- Set up parameters. ---
% --- INSERT YOUR CODE HERE.
k=5; % number of bits per symbol
Nsymb=2000; % number of symbols in each run
nsamp=256; % oversampling,i.e. number of samples per T
% Simulate until number of errors exceeds maxNumErrs
% or number of bits processed exceeds maxNumBits.
while((totErr < maxNumErrs) && (numBits < maxNumBits))
 % Check if the user clicked the Stop button of BERTool.
 if (BERTool.getSimulationStop)
 break;
 end
 % Β. --- INSERT YOUR CODE HERE.
 errors=fsk_errors_noncoherent(k,Nsymb,nsamp,EbNo);
 % Assume Gray coding: 1 symbol error ==> 1 bit error 
 totErr=totErr+errors; 
 numBits=numBits + k*Nsymb;
end % End of loop
% Compute the BER
ber = totErr/numBits;