function [minFreqIdx] = lowFrequencyEstimation(U, numSSV)
  
  % Figure out which group has the low-frequency data and that will be the
  % long-term trend
  F = abs(fft(U(:,1:numSSV)));
  F = F(1:floor(size(U,1)/2),:);
  [~,freqIdx] = max(F,[],1);
  [~,minFreqIdx] = min(freqIdx);

end