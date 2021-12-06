function res = mvOutlier(inpData, chiProb, mPlots)
  % mvOutlier odhadne hodnotym podozrive z odlahlosti. Postup je zalozeny na odhade kvadratu 
  % Mahalanobisovej vzdalenosti, pre ktory plati predpis v tvare
  % 
  %     md2 = (xi - mX) * inv(C) * (xi - mX)', kde
  %        xi... je prvok matice X, 
  %        x ... je NxP matica, ktera obsahuje P-rozmerov (P-parametrov),
  %        mX... je odhad viacejrozmernej centroidnej polohy (multivariate location estimator),
  %        C ... je kovariancna matica (inv je inverze matice),
  %        ' ... znaci transponovanu matici.
  % 
  % Porovnavaju sa odhady Mahalanobisovych vzdalenosti s kritickou hranicou, ktora je odhadnuta na 
  % zaklade chi-kvadrat rozdelenia. Mahalanobisove vzdalenosti, ktere prekrocia odhadnutu kriticku
  % hodnotu su potom podezrive z odlehlosti. Je to viacparametricka metoda, a teda lze pouzit aj
  % viacrozmernu maticu inpData (nemusi byt nutne vektor).
  
  % Overenie rozmeru
  [nData, pDim] = size(inpData);
  if nData < pDim
  
    inpData = inpData';
    [nData, pDim] = size(inpData);
    
  end
  
  % Vypocet. Data by nemali obsahovat nan hodnoty. Asi uz nutne osetrit este pred pouzitm funkcie.
  % Obecne, chybajuce data, ci nany by sa mali vhodne aproximovat.
  rMat = inpData - median(inpData, 'omitnan'); % mozno v R2007 a starsej omitnan neexistuje.
  
  % Kontrola vycentrovanej rMat
  chSum = sum(rMat,1);
  id = find(chSum == 0, 1);
  if ~isempty(id)
    
    rMat(:,id) = rMat(:,id) + rand() * 0.0001;
  end
    
  %covMatX = ((rMat' * rMat) / (nData - 1)).*ones(pDim , pDim, nData);
  covMatX = (rMat' * rMat) / (nData - 1);
  
  % Odhad Mahalanobisovych vzdalenosti
  mDSq = diag(rMat / (covMatX) * rMat');
  
  % Testovanie hypotezy o odlehlosti 
  vecOutliers = ~chi2Decision(mDSq, chiProb, pDim).*(1:nData)';
  vecOutliers = vecOutliers(vecOutliers ~= 0);
  nOutliers = length(vecOutliers);
  
  critVal = chi2Quantile(chiProb, pDim);

  % Vykreslenie
  if mPlots 
    
    if pDim > 5
    
      warning ('ERA:mvOutlier:plotLimitation', 'Kresli maximalne 5-parametru!')
    else
  
      plotSituation(inpData, mDSq, vecOutliers, critVal)
    end
  end
    
  res = struct('covMat',         covMatX(:,:,1),...
               'md2',            mDSq,...
               'critVal',        critVal, ...
               'nOutliers',      nOutliers,...
               'vecOutliersIdx', vecOutliers);
end

