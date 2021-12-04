function [qData] = quantile(data, p)
  % QUANTILE funkcia spocita p-kvantil. Poznamka, p = 0.5 = median
  
  dataLen = size(data, 1);
  dataSort = sort(data, 1);
    
  idx = (2 * dataLen * p + 1) / 2;
  idx(idx <= 1) =  1;
  idx(idx >= dataLen) = dataLen;
  idxF = floor(idx);
    
  dataSort(end+1, :) = 1;
  qData = dataSort(idxF,:) + (dataSort(idxF+1,:) - dataSort(idxF,:)).* (idx - idxF).';
end
