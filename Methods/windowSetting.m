function  [window, nWindow] = windowSetting(window, nSamples)

  if isempty(window)
  
    nWindow = floor(nSamples/4.5);
    window = hamming(nWindow, 'Alpha', 0.54);
    % window = window(1:end-1);
  elseif isscalar(window)
    
    nWindow = window;
    window = hamming(nWindow, 'Alpha', 0.54);
    % window = window(1:end-1);
  else
    
    nWindow = length(window);
  end
end