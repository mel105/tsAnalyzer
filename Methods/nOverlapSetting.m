function [nOverlap] = nOverlapSetting(nOverlap, nFFT, nSamples)
  
  if isempty(nOverlap)
    if isempty(nFFT)
      nOverlap = floor(floor(nSamples/4.5)/2);
    else
      nOverlap = floor(nFFT/2);
    end
  end
end