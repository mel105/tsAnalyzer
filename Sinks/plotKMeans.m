function []=plotKMeans(clusters, clustersIdx, grpSamplesIdx)

  % vyplotenie klustrovania
  
nClusters = length(clusters);

  figure('Name','k-means')
  colors = {'r.','b.','g.','y.','m.','c.','k.'};
  %plot(clusterCenters,'k*', 'MarkerSize',15);
  %hold on;
  for iCluster = 1:nClusters
    currCluster = clusters{iCluster};
    currIdx = clustersIdx{iCluster};
    plot(grpSamplesIdx(currIdx), currCluster,colors{iCluster}, 'MarkerSize',15);
    hold on;
  end
  
end