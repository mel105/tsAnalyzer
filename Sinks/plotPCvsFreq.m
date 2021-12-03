function [] = plotPCvsFreq(data, elemTS, elemYDft, elemFreq, estPerVec)
 
  [~, nCol] = size(elemTS);


  fo = figure("Name", "PC vs. Freq");
  tiledlayout(fo, nCol+1, 6, "TileSpacing", "compact")
  nexttile(1, [1 6]);
  plot(data, '-');

  for iCol = 1:nCol

    nexttile((iCol*6+1), [1 3]);%7
    plot(elemTS(:,iCol), '-')
    my = sprintf("F"+"%s",num2str(iCol));
    ylabel(my)

    nexttile((iCol*6+4), [1 3]) %10
    loglog(1./elemFreq(:,iCol), abs(elemYDft(:,iCol)), '-'), %ylabel('|DFT\{F(k)\}|')%, xlabel('s^{-1}')
    mt = sprintf("%4.2f",estPerVec(iCol));
    title(mt);
  end

end