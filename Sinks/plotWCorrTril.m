function []=plotWCorrTril(Wcorr)

  Wcorr = Wcorr(tril(true(M), -1));
  
  figure('Name','W-CORR tril')
  plot(Wcorr, '.')
end