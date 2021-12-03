function [seasMatrix, clusters, clustersIdx, clusterCenters, grpSamplesIdx] =  ...
    wcorrProcessing(Wcorr, numClusters, M)
  % WCORRPROCESSING spracuje w correlation maticu a vrati niektore vybrane parametre, ako napr.
  % seasMatrix, clustr atp. Klustre su pocitane pomocou externej funkcie kMeansClustering. Tu nemam
  % uplne osahanu, takze nelze rucit za vysledok. Snaha bude tuto funkciu ignorovat.

  % dolna trojuholnikova matica
  WcorrFull = tril(Wcorr, -1);

  Wcorr = Wcorr(tril(true(M), -1));

  grpSamplesIdx = (1:1:length(Wcorr));

  wIdx = Wcorr <= 0.3;
  WcorrRed=Wcorr;
  WcorrRed(wIdx) = [];
  grpSamplesIdx(wIdx) = [];

  if (length(WcorrRed) < numClusters)

    numClusters = length(WcorrRed) -1;
  end

  if numClusters <= 0

    numClusters = 1;
  end

  % grupovanie korelacii do clustrov. Zmysel je ten, ze ak vyznamnejsich komponent je viacej, potom
  % na zaklade klustrovacieho procesu ich zoradim do logickych skupin a z nich potom zlozim
  % jednotlive periodicke zlozky.
  [clusters, clustersIdx, clusterCenters] = kMeansClustering(WcorrRed, numClusters, 25);


  % vysledky clustrovania porovnam s matickou WcorrFull. Vysledky hladania su indexy matice a tie mi
  % reprezentuju cisla komponenty.
  seasMatrix = [];
  nClusters = length(clusters);
  for iCluster = 1:nClusters

    nPixels = length(clusters{iCluster});
    for iPixel = 1:nPixels

      [iRow, iCol] = find(WcorrFull == clusters{iCluster}(iPixel));
      %
      seasMatrix = [seasMatrix; iCluster, clusters{iCluster}(iPixel), iRow, iCol];
    end
  end
end