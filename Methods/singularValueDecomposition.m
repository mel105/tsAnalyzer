function [U, S, V] = singularValueDecomposition(trajMat)
  % funkcia spracuje dekompoziciu singularnych hodnot. K tomu sa pouziju matlabovske funkcie
  % U
  % S
  % V
  [U, S, V] = svdsketch(trajMat);
  
  if size(S,1) < 3
    
    [U,S,V] = svd(X);
  end



  %{
  % .v SSA zargone, TM sa tiez vola 'embedded time series'
  C = trajMat' * trajMat / K;

  % .V je matica, ktorej stlpce obsahuju vlastne vektory: C*V = V*lambda
  % .D je matica obsahujuca vlastne cisla (na diagonale)
  [V, D] = eig(C);
  D = diag(D);
  [D, idx]=sort(D,'descend');
  V = V(:,idx);

  %sev=sum(D); 
	%plot((D./sev)*100),hold on,plot((D./sev)*100,'rx');
	%title('Singular Spectrum');xlabel('Eigenvalue Number');ylabel('Eigenvalue (% Norm of trajectory matrix retained)')

  % . hlavne komponenty
  PC = trajMat * V;

  figure(999);
  set(gcf,'name','Principal components PCs')
  clf;
  for m=1:nc
    subplot(nc,1,m);
    plot(1:size(trajMat,1), PC(:,m),'k-');
    ylabel(sprintf('PC %d',m));
    ylim([-10 10]);
  end
  %}
  
  
  %{
  figure('Name', 'Kov. matica');
  imagesc(C);
  axis square
  set(gca,'clim',[-1 1]);
  colorbar
  %}
    
  %{
 
  figure('Name', 'SVD')
  loglog((1:length(D)), D)
  hold on
  loglog((1:length(D)), D,'rx');
  title('Singular Spectrum');
  xlabel('Eigenvalue Number');
  ylabel('Eigenvalues')
  %}
  
  
  %{
  figure('Name','Principal components');
  clf;
  LL = 5;
  
  if LL > L
    LL = ceil(L/2);
  end
  
  for m=1:LL
    subplot(LL,1,m);
    plot(PC(:,m),'k-');
    ylabel(sprintf('PC %d',m));
  end
  %}

end