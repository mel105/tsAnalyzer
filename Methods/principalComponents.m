function elemTS = principalComponents(s,U,V,M)

  % Convert the elementary matrices to timeseries by diagonal averaging since
  % the elementary matrices won't be exactly hankel
  L = size(U,1);
  K = size(V,1);
  N = K + L - 1;
  
  elemTS = zeros(N,M);
  numAntiDiag = K + min(1-K:L-1,0) + min(L-1:-1:1-K,0);
  for j = 1:M
    elemTS(:,j) = s(j) * conv(U(:,j), V(:,j)) ./ numAntiDiag.';
  end
end
