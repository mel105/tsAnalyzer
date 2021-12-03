function []=plotTrajectoryMatrix(T)
  
  figure('Name', 'Trajectory matrix');
  imagesc(T);
  axis square
  set(gca,'clim',[-1 1]);
  colorbar
end