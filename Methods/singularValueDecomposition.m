function [U, S, V] = singularValueDecomposition(trajMat)
  % SINGULARVALUEDECOMPOSITION funkcia spracuje dekompoziciu singularnych hodnot. K tomu sa pouziju
  % matlabovske funkcie. Mali by pracovat aj pre starsie verzie matlabu.

  [U, S, V] = svdsketch(trajMat);
  
  if size(S,1) < 3
    
    [U,S,V] = svd(X);
  end
end