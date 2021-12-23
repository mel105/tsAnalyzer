function [wcorr] = wcorrelation(elemTS, N, L, K, M)
 % WCORRELATION funkcia vrati maticu, wcorr, ktora obsahuje vzajomne vahovane korelacie medzi
 % jednotlivymi hlavnymi komponentami elemTS.

  weights = [1:L,L*ones(1,K-L-1),N:-1:K];
  normElemTS = zeros(1,M);

  for k = 1:M

    normElemTS(k) = dot(weights,elemTS(:,k).^2);
  end

  normElemTS = sqrt(normElemTS);

  %
  %W = sum(weights(:) .* elemTS .* reshape(elemTS, N, 1, M), 1);
  %W = reshape(W, M, M);

  W = zeros(size(elemTS,2), size(elemTS,2));
  for i = 1:size(elemTS,2)
    for j = 1:size(elemTS,2)
      
      sm = 0;
      for k = 1:size(elemTS,1)

        sm = sm+(weights(1,k)*elemTS(k,i)*elemTS(k,j));
      end
      
      W(i,j) = sm;
    end
  end
  
  %wcorr = abs(W)./(normElemTS.*normElemTS');
  men = mytimes(normElemTS, normElemTS'); 
  wcorr = abs(W)./men;
end