function [Wcorr] = wcorrelation(elemTS, N, L, K, M)
 % WCORRELATION funkcia vrati maticu -Wcorr-, ktora obsahuje vzajomne vahovane korelacie medzi
 % jednotlivymi hlavnymi komponentami -elemTS.

  weights = [1:L,L*ones(1,K-L-1),N:-1:K];
  normElemTS = zeros(1,M);

  for k = 1:M

    normElemTS(k) = dot(weights,elemTS(:,k).^2);
  end

  normElemTS = sqrt(normElemTS);

  weightsElemTSElemTS = sum(weights(:) .* elemTS .* reshape(elemTS, N, 1, M), 1);

  weightsElemTSElemTS = reshape(weightsElemTSElemTS, M, M);

  Wcorr = abs(weightsElemTSElemTS) ./ (normElemTS .* normElemTS');
end