function [] = plotWCorrelationMatrix(Wcorr)

  figure('Name','W-CORR')
  imagesc(Wcorr)
  colormap(flipud(gray(256)))
  cobj = colorbar;
  %xlabel("$\tilde F\_{i}$", 'Interpreter','latex');
  %ylabel("$\tilde F\_{j}$", 'Interpreter','latex');
  %ylabel(cobj, "$W\_{i,j}$", 'Interpreter','latex')
  xlabel("F(i)");
  ylabel("F(j)");
  ylabel(cobj, "W(i,j)")
  set(gca,'YDir','normal')
end