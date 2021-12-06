function [figA, figB, figC, figScrMat] = plotScreening(inpDistorData, inpScreenData, scrSummary)


 % plot original situation
  figA = figure("Name", "Before Screening situation", "Visible", "off");
  axesObjA = axes(figA);
  plot(inpDistorData, ".");
  axesObjA.Title.String = "Situation before the screening exploration";
  axesObjA.XLabel.String =  "time [idx]";

  % plot screening details
  figScrMat = []; % Matica formatu Nx2 obsahuje v riadku pary obrazkov, z nich jeden vyjadruje stav 
  % Mahalanobisovych vzdialenosti a kritickej hladiny a druhy z nich obsahuje zvyraznene vzorky
  % podozrive z odlahlosti.
  for i = 1:size(scrSummary.figureDataMat, 2)
  
    X = scrSummary.figureDataMat{2, i};
    mDSq = scrSummary.figureDataMat{3,i};
    out = scrSummary.figureDataMat{4,i};
    chiEst = scrSummary.figureDataMat{5,i};

   [fo1, fo2] = plotSituation(X, mDSq, out, chiEst);
   figScrMat = [figScrMat; fo1, fo2]; %#ok
  end

  % heighlight suspected values
  nScrSum = size(scrSummary.figureDataMat, 2);
  sumSuspVal = 0; %... celkove mnozstvo outliers
  suspTimeVec = [];
  for i = 1:nScrSum
    sumSuspVal = sumSuspVal + length(scrSummary.figureDataMat{4,i});
    suspTimeVec = [suspTimeVec; scrSummary.figureDataMat{1,i}(scrSummary.figureDataMat{4,i})]; %#ok
  end

  suspTimeVec = sort(suspTimeVec);
  [suspIdx,~]=ismember(1:1:size(inpDistorData,1), suspTimeVec);
  suspVal = inpDistorData(suspIdx);

  % plot original situation
  figB = figure("Name", "Highlighting (gray) of suspected samples", "Visible","off");
  axesObjB = axes(figB);
  plot(inpDistorData, ".");
  hold on
  plot(suspTimeVec, suspVal,"o","MarkerSize",8,"MarkerEdgeColor","k","MarkerFaceColor","#808080");
  axesObjB.Title.String = "Highlighting (gray) of suspected samples";
  axesObjB.XLabel.String = "time [idx]";

  % screened data
  figC = figure("Name", "Screened series", "Visible", "off");
  axesObjC = axes(figC);
  plot(inpScreenData, ".");
  axesObjC.Title.String = "Situation after the screening exploration";
  axesObjC.XLabel.String = "time [idx]";
end


% Local Functions
function [fo1, fo2] = plotSituation(X, mDSq, out, chiEst)
  % plotSituation funkcia vykresli dva obrazky: 
  %   1) Priebehy dat v matici x (kazdy stlpec matice = jeden subplot) a zobrazi pripadne hodnoty 
  %      podezrive z odlehlosti. 
  %   2) Zobrazi Mahalanobisove vzdalenosti a odhad kritickej hodnoty. Jsou zde tez zvyraznene hodnoty,
  %      ktere prekrocily kriticku hodnotu a jsou proto podezrele z odlehlosti.

  tIdx = 1:1:size(X,1); % indexy na casove ose
  pDim = size(X,2); % dim - pocet subplotu na jednom obrazku
  
  % Zobrazeni matice x (sloupec = samostatny subplot) a detekovanych outliers
  fo1 = figure("Name", "Input data vs. suspected samples", "Visible", "off");
  ha = zeros(pDim, 1);
  for iPlot = 1:pDim
    
    ha(iPlot) = subplot(pDim, 1, iPlot);
    plot(tIdx, X(:,iPlot),  ".", "MarkerEdgeColor", [0, 0.4470, 0.7410], "MarkerSize", 7)
    hold on
    plot(out, X(out, iPlot), ".", "MarkerEdgeColor", [250,128,114]/255, "MarkerSize", 8);
    
    ylabel({iPlot}, "FontSize", 7, "FontWeight", "bold")
    
    if iPlot == 1
      
      legend("Data", "Outliers", "Orientation", "horizontal", "Location", "best")
      
      axlim = get(gca, "XLim");                
      aylim = get(gca, "YLim");                
      xTxtCrd = min(axlim) - 0.125*diff(axlim);
      yTxtCrd = min(aylim) + diff(aylim) + 0.15*diff(aylim);
      text(xTxtCrd, yTxtCrd, "Col. #:")
    end
  end
  
  xlabel("TIME [IDX]", "FontSize", 10, "FontWeight", "bold")
  linkaxes(ha, "x")
  linkdata("on")
  
  fo2 = figure("Name", "Mahalanobis distances vs. critcal value estimation", "Visible", "off");
  a = stem(tIdx, mDSq, "LineStyle", "-");
  a.Marker = "none";
  if ~isempty(out)
    hold on
    s = stem(tIdx(out), mDSq(out), "LineStyle","-") ;
    s.Color = "red";
    s.MarkerFaceColor = "red";
  end
  hold on
  yline(chiEst, "-black", "Threshold", "LineWidth", 3)
  xlabel("TIME [IDX]", "FontSize", 10, "FontWeight", "bold")
  ylabel("md^2", "FontSize", 10, "FontWeight", "bold")
  if ~isempty(out)
    legend("md^2", "\chi^2", "Orientation","horizontal", "Location", "best")
  else
    legend("md^2","md^2 > \chi^2","\chi^2", "Orientation","horizontal", "Location", "best")
  end
end