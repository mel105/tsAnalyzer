function [wCorrStruct, clusterStruct] = grouping(U, S, V, L, K, N, numST)
  % GROUPING z rozkladu Henkel matice a z matice sigma S, z diagonaly si vezmeme hodnoty singularnych bodov
  % a tie normujeme.
  
  SSV = diag(S);
  relContrib = ((SSV.^2)./sum(SSV.^2));

  % odhad dominantych sign. values. MELTODO: tu by slo popracovat, z hodnot dominantnych values
  % vybrat na zaklade nejakeho kriteria len tie, ktore by sa uz dalej nemuseli clustrovat a ktore by
  % sa inak rozlozili na vyznamne komponenty. Napr. pomocou Mahalanobis vzdialenosti, quantiloveho
  % rozdelenia? Nemam to uplne premyslene, ale clustrovanie moze byti obcas komplikovane.
  ssvLimit = 0.01;
  numSSV = sum(relContrib >= ssvLimit);

  % Overenie poctu vyznamnych ssv (significant signular values).
  if numSSV < 3 && isempty(numST)
    numST = 1;
    numSSV = 3;
  end

  % Ak mam zadany pocet Seasonal trends (numST), musim si opravit pocet vyznamnych komponent numSSV.
  if ~isempty(numST)
    
    numSSV = min(numel(SSV), max(numSSV, 2*numST + 1));
  end

  % Vypocet hlavnych komponent
  elemTS = principalComponents(SSV, U, V, numSSV);

  % Odhad W-Correlation - vahovej korelacie
  [Wcorr] = wcorrelation(elemTS, N, L, K, numSSV);

  % Spracovanie vzajomnych korelacii
  % zmyslom nasledujucej casti je z dostupnych korelacii odhadnut tie, ktore su z pohladu 
  % rekonstrukcie signalu vyznamne a zaujimave a tie ostatne komponenty prehlasit za sum.
  numClusters = 7; % MELTODO: numclusters do setting
  [seasMatrix, clusters, clustersIdx, clusterCenters, grpSamplesIdx] = ...
    wcorrProcessing(Wcorr, numClusters, numSSV);
  
  if isempty(numST)

    numST = length(clusters);
  end

  [minFreqIdx] = lowFrequencyEstimation(U, numSSV);

  clusterStruct = struct(...
    "clusters", clusters, ...
    "clustersIdx", clustersIdx, ...
    "clusterCenters", clusterCenters);

  wCorrStruct = struct(...
    "Wcorr", Wcorr, ...
    "seasMatrix", seasMatrix, ...
    "grpSamplesIdx", grpSamplesIdx, ...
    "minFreqIdx", minFreqIdx, ...
    "numSSV", numSSV, ... M
    "numST", numST, ...
    "elemTS", elemTS);
end