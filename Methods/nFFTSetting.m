function [nFFT] = nFFTSetting(nFFT, nOverlap, nSamples)

  if isempty(nFFT)
  
    nFFT = 2^nextpow2(2*nOverlap);
    if nSamples > 255
    
      nFFT = max(256, nFFT);
    end
  elseif ~isscalar(nFFT)

    error('Input is not supported. Frequency vector has dimension [%d %d]. Scalar is expected!',...
      size(nFFT,1), size(nFFT,2))
  end

end