function [res] = tsa(timeVec, valuesVec, cfg)

  % funkcia, ktora ma na vstupe pozdavovane vlastnostia  vrati pozadovanu structuru.

  % odhad trendu
  switch cfg.trendEstimation
    case "Linear"

      [rc, trendStruct] = linearRegression(timeVec, valuesVec);
      plotLinearRegression(timeVec, valuesVec, trendStruct)
    case "Harmonic"
    otherwise
      error("Required method is not implemented!");
  end

  res = struct(...
    "trend", nan, ...
    "periodic", nan, ...
    "residuals", nan);
end