function [harmVec] = signalGenerator(signalDuration, samplingFr, signalFreq, signalPhas, signalAmpl, wNoiseAmpl)
  %X = signalGenerator(limitTras, integInter, signalDur, samplingFr, signalFreq, signalPhas, signalAmpl, wNoiseAmpl);

  nFreq = length(signalFreq);
  harmVec = complex(0,0);

  samplingTs = 1/samplingFr;
  samplesNo = samplingFr*signalDuration;
  samplingTVec = 0 : samplingTs : (samplesNo) / samplingFr;

  for iFreq = 1:nFreq

    harmVec = harmVec + signalAmpl(iFreq) * complex(...
      cos(2*pi*signalFreq(iFreq) * samplingTVec + signalPhas(iFreq)), ...
      sin(2*pi*signalFreq(iFreq) * samplingTVec + signalPhas(iFreq))) ...
      + wNoiseAmpl(iFreq) * complex( ...
      randn(size(samplingTVec)),...  % noise: real part
      randn(size(samplingTVec)));    % noise: imag part
  end

end