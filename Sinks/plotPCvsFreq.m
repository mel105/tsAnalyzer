function [] = plotPCvsFreq(elemTS, elemYDft, elemFreq, estPerVec)

  [nRow, nCol] = size(elemTS);

  figure("Name", "PC vs. Freq");
  ha = zeros(nCol, 2);
  
  idx = 0;
  for iCol = 1:nCol

    ha(iCol,1) = subplot(nCol, 2, iCol+idx);
    plot(elemTS(:,iCol), '-')
    my = sprintf("F"+"%s",num2str(iCol));
    ylabel(my)

    ha(iCol,2) = subplot(nCol, 2, iCol+idx+1);
    loglog(1./elemFreq(:,iCol), abs(elemYDft(:,iCol)), '-'), %ylabel('|DFT\{F(k)\}|')%, xlabel('s^{-1}')
    mt = sprintf("%4.2f",estPerVec(iCol));
    title(mt);

    idx = idx+1;
  end
end