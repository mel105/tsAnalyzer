function [dataSTFT, freqVec, indCenterVec, dataPSD] = spectrogram(X, window, nOverlap, nFFT, fs,...
    freqRange)
  % SPECTROGRAM using short-time Fourier transform
  %
  %
  %   s = SPECTROGRAM(x)
  %   s = SPECTROGRAM(x, window)
  %   s = SPECTROGRAM(x, window, nOverlap)
  %   s = SPECTROGRAM(x, window, nOverlap, nFFT)
  %   s = SPECTROGRAM(x, window, nOverlap, nFFT, fs)
  %   s = SPECTROGRAM(x, window, nOverlap, nFFT, fs, freqRange)
  %
  %   [s, f, t] = SPECTROGRAM(___)
  %   [s, f, t, ps] = SPECTROGRAM(___)
  %
  %  INPUT ARGUMENTS:
  %
  % * x         - inputDataVec - input signal
  % * window    - custom window or length of hamming window
  % * nOverlap  - samples of overlap between adjoining segments
  % * nFFT      - n-point discrete Fourier transform
  % * fs        - sampling frequency
  % * freqRange - frequency range 'onesided', 'twosided' or 'centered'
  %
  %  OUTPUT ARGUMENTS:
  %
  % * no output argument => plot spectrogram
  % * s   - Short-Time Fourier Transform
  % * f   - frequency vector
  % * t   - vector of time instants, at which the spectrogram is computed
  % * ps  - estimate of power spectral density (PSD)

  nSamples = length(X);

  % kontrola, ze ci kontajner data nie je prazdna mnozina
  assert(~isempty(X), "Na vstupe nie su ziadne data");
  assert(nSamples>3, "Nevhodna dimenzia vstupnych dat");

  % kontrola okna/window
  [window, nWindow] = windowSetting(window, nSamples);

  % kontrola prekrytu
  [nOverlap] = nOverlapSetting(nOverlap, nFFT, nSamples);

  % kontrola rozmeru dat do FFT
  [nFFT] = nFFTSetting(nFFT, nOverlap, nSamples);
  
  % nastavenie nOverlap musi byt mensie nez je velkost hodnoty window
  assert( nOverlap < nWindow, 'nOverlap must be smaller than the length of window! (%d \leq %d)',...
    nOverlap, nWindow)

  nColumns = floor((nSamples-nOverlap)/(nWindow-nOverlap));

  % kontrola vzorkovacej frekvencie
  [fs] = fsSetting(fs);
  
  % kontrola rozsahu frekvencneho spektra
  [nRows, callFftShift] = freqRangeSetting(freqRange, X, nSamples, nFFT);
     
  % algoritmus
  if ~any(size(X).*size(window)==1)
  
    window = window.';
  end
  
  nRows = round(nRows);
  dataSTFT  = NaN(nRows, nColumns);
  dataPSD   = NaN(nRows, nColumns);
  
  if callFftShift
  
    freqVec = linspace(-0.5, 0.5, nFFT) * fs;
  else
    
    freqVec = linspace(0, 1, nFFT) * fs;
  end

  indStart = 1 - (nWindow - nOverlap);
  indCenterVec = zeros(1, nColumns);
  for iC = 1:nColumns
  
    indStart = indStart + (nWindow - nOverlap);
    indStop =  indStart + nWindow - 1;
    indCenterVec(1,iC) = indStart + nWindow/2;
    
    currentData = window .* X(indStart:indStop);
    currentSTFT =  fft(currentData, nFFT);
    
    if callFftShift
    
      currentSTFT = fftshift(currentSTFT);
    end
    
    dataSTFT(1:nRows,iC) = currentSTFT(1:nRows);
    dataPSD(1:nRows,iC) = 2/(fs*nSamples) * abs(currentSTFT(1:nRows)).^2;
  end

  indCenterVec = indCenterVec./fs;
  freqVec = freqVec(1:nRows);
end