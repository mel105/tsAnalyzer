function [fo] = plotSpectrogram(X, T, timeUnit, timeAxis, freqAxis, dataSTFT)

  %Plot spectrogram to a new figure
  %
  %  INPUT ARGUMENTS:
  %
  % * timeAxis - Time Axis
  % * freqAxis - Frequency Axis
  % * dataSTFT - Short-Time Fourier Transform
  %
    
  minTime = min(T);
  maxTime = max(T);


  dataSTFT(abs(dataSTFT)==0) = eps; % osetreni zobrazeni logaritmu nuly

  fo = figure('Name', 'Spectrogram');
  ax1 = subplot(2,1,1);
  plot(T, abs(X), '.-');
  xlabel("Time ["+timeUnit+"]")
  ax2 = subplot(2,1,2);
  imagesc(timeAxis, freqAxis, 10*log10(abs(dataSTFT)));
  %imagesc(timeAxis, freqAxis, abs(dataSTFT))
  xlabel("Time ["+timeUnit+"]")
  ylabel("Normalized frequency")
  cBarH = colorbar;
  colormap(bone);
  cBarH.Label.String = "Power/frequency";

  ax1.XLim = [minTime maxTime];
  ax2.XLim = [minTime maxTime];

end