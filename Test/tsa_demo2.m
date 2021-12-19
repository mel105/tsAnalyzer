% tsa demo 2: Setreny signal je umelo generovany.
clear variables;
close all;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

% vygenerovanie signalu
t = (1:200)';
trend = 0.001*(t-100).^2;
period1 = 20;
period2 = 30;
seasonal1 = 2*sin(2*pi*t/period1);
seasonal2 = 0.75*sin(2*pi*t/period2);
noise = 2*(rand(200,1) - 0.5);

X = trend + seasonal1 + seasonal2 + noise;

X = X - mean(X);
X = X / std(X);

% 
%SSA(signalVec, 'L', 20);
figure(2); plot(X, '.')
% 
 %  SYNTAX:
  %
  %   SPECTROGRAM(x)
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

  
  spectrogram(X, 'window', 10, 'nOverlap', 10, 'nFFT', 10, 'fs', 1, 'freqRange', 'centered')