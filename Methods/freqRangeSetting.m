function [nRows, callFftShift] = freqRangeSetting(freqRange, X, nSamples, nFFT)
    
  checkParam(freqRange, ["oneside", "twoside", "centered", "default"])

  if strcmpi(freqRange, "default")

    if isreal(X)
    
      freqRange = "onesided";
    else
  
      freqRange = "twosided";
    end
  end
  
  if isreal(X) && strcmpi(freqRange, "onesided")
  
    if mod(nSamples, 2)
    
      nRows = (nFFT + 1)/2;
    else
    
      nRows = nFFT/2 + 1;
    end
  
  elseif ~isreal(X) && strcmpi(freqRange, "onesided")
  
    checkParam(freqRange, {'twosided','centered'})
  else
  
    nRows = nFFT;
  end
  
  callFftShift = false;
  
  if strcmpi(freqRange, "centered")
  
    callFftShift = true;
  end
  
end

%% loc fnc
function [] = checkParam(param, vec)
  
  nVecs = length(vec);
  status = false;
  for iVec = 1:nVecs

    if (param == vec(iVec))

      % ok
      status = true;
      break;
    end
  end

  if status == false
    
    error("Input parameter must be member of input vector!");
  end
end