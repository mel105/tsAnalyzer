function []=plotSingularValues(S)

  ss = diag(S);
  normsv = ((ss.^2)./sum(ss.^2));

  figure("Name","Singular values")
  plot(normsv, '.')
  hold on
  yline(0.01, 'r-')
end