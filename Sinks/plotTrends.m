function [] = plotTrends(data, LT, ST, R)
  
  figure('Name',"ANAL")
  seasLab = [];
  subplot(2,1,1)
  plot(data, '-')
  hold on
  plot(LT, '-', 'LineWidth',1.5)
  seasNum = size(ST,2);
  seasLab = ["Data", "Long-Term"];
  for i = 1:seasNum
    hold on
    plot(ST(:,i), '-', 'LineWidth',1.5)
    lab = sprintf("Seas-Term-%s",num2str(i));
    seasLab = [seasLab, lab];
  end
  
  legend(seasLab)
  subplot(2,1,2)
  plot(R, '-', 'LineWidth',1.5)
  legend("NOISE")
end