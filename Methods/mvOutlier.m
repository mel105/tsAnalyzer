function res = mvOutlier(x, chiProb, mPlots)
  % mvOutlier odhadne hodnotym podozrive z odlahlosti. Postup je zalozeny na odhade kvadratu 
  % Mahalanobisovej vzdalenosti, pre ktory plati 
  % predpis je dany ve tvaru
  % 
  %     md2 = (xi - mX) * inv(C) * (xi - mX)', kde
  %        xi... je prvok matice X, 
  %        x ... je NxP matica, ktera obsahuje P-rozmerov (P-parametrov),
  %        mX... je odhad viacejrozmernej centroidnej polohy (multivariate location estimator),
  %        C ... je kovariancna matica (inv je inverze matice),
  %        ' ... znaci transponovanu matici.
  % 
  % Porovnavaju sa odhady Mahalanobisovych vzdalenosti s kritickou hranicou, ktora je odhadnuta na 
  % zaklade chi-kvadrat rozdelenia. Mahalanobisovy vzdalenosti, ktere prekroci odhadnutou kritickou
  % hodnotu su podezrive z odlehlosti
  
  % Overenie rozmeru
  [nData, pDim] = size(x);
  if nData < pDim
  
    x = x';
    [nData, pDim] = size(x);
    
  end
  
  % Vypocet
  rMat = x - median(x, 'omitnan');
  
  % Kontrola vycentrovanej rMat
  chSum = sum(rMat,1);
  id = find(chSum == 0, 1);
  if ~isempty(id)
    
    rMat(:,id) = rMat(:,id) + rand()*0.0001;
  end
    
  %covMatX = ((rMat' * rMat) / (nData - 1)).*ones(pDim , pDim, nData);
  covMatX = (rMat'*rMat)/(nData-1);
  
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
  
      plotSituation(x, mDSq, vecOutliers, critVal)
    end
  end
    
  res = struct('covMat',         covMatX(:,:,1),...
               'md2',            mDSq,...
               'critVal',        critVal, ...
               'nOutliers',      nOutliers,...
               'vecOutliersIdx', vecOutliers);
end

% Local Functions
function plotSituation(X, mDSq, out, chiEst)
  % plotSituation funkcia vykresli dva obrazky: 
  %   1) Priebehy dat v matici x (kazdy stlpec matice = jeden subplot) a zobrazi pripadne hodnoty 
  %      podezrive z odlehlosti. 
  %   2) Zobrazi Mahalanobisove vzdalenosti a odhad kritickej hodnoty. Jsou zde tez zvyraznene hodnoty,
  %      ktere prekrocily kriticku hodnotu a jsou proto podezrele z odlehlosti.

  tIdx = 1:1:size(X,1); % indexy na casove ose
  pDim = size(X,2); % dim - pocet subplotu na jednom obrazku
  
  % Zobrazeni matice x (sloupec = samostatny subplot) a detekovanych outliers
  figure('Name', 'Zobrazenie vstupnych dat a detekovanych outliers')
  ha = zeros(pDim, 1);
  for iPlot = 1:pDim
    
    ha(iPlot) = subplot(pDim, 1, iPlot);
    plot(tIdx, X(:,iPlot),  '.', 'MarkerEdgeColor', [0, 0.4470, 0.7410], 'MarkerSize', 7)
    hold on
    plot(out, X(out, iPlot), '.', 'MarkerEdgeColor', [250,128,114]/255, 'MarkerSize', 8);
    
    ylabel({iPlot}, 'FontSize', 7, 'FontWeight', 'bold')
    
    if iPlot == 1
      
      legend('Data', 'Outliers', 'Orientation', 'horizontal', 'Location', 'best')
      
      axlim = get(gca, 'XLim');                
      aylim = get(gca, 'YLim');                
      xTxtCrd = min(axlim) - 0.125*diff(axlim);
      yTxtCrd = min(aylim) + diff(aylim) + 0.15*diff(aylim);
      text(xTxtCrd, yTxtCrd, 'Col. #:')
    end
  end
  
  xlabel('TIME [IDX]', 'FontSize', 10, 'FontWeight', 'bold')
  linkaxes(ha, 'x')
  linkdata('on')
  
  figure("Name", "Kvadraty Mahal vzdialenosti a kriticka hodnota")
  a = stem(tIdx, mDSq, 'LineStyle', '-');
  a.Marker = 'none';
  if ~isempty(out)
    hold on
    s = stem(tIdx(out), mDSq(out), 'LineStyle','-') ;
    s.Color = 'red';
    s.MarkerFaceColor = 'red';
  end
  hold on
  yline(chiEst, '-black', 'Threshold', 'LineWidth', 3)
  xlabel('TIME [IDX]', 'FontSize', 10, 'FontWeight', 'bold')
  ylabel('md^2', 'FontSize', 10, 'FontWeight', 'bold')
  if ~isempty(out)
    legend('md^2', '\chi^2', 'Orientation','horizontal', 'Location', 'best')
  else
    legend('md^2','md^2 > \chi^2','\chi^2', 'Orientation','horizontal', 'Location', 'best')
  end
end