function [scrData, summary] = screening(inpData, cdfProbConstant, screeningPlot)
  % SIMPLESCREENING moderuje precistenie dat od hodnot podzrivych z odlahlosti v cykluse.

  % data dimenstion
  nOrig = height(inpData);
  nRem = 0;
  idxTime = (1:1:nOrig)';

  % stop crit.
  stopCrit = 0;

  % cycle number
  loopIdx = 0;

  % data collecting for the purpose of screening figure plotting. In case, that the
  % simpleScreeningFigureinfoMat is not empty (empty is only in case of no outliers), the array
  % structure is as follows: number of columns simpleScreeningFigureMat represents the number of
  % figures (or figure pairs) that should be plotted (simpleScreening is based on a cycling process
  % of detection. Every cycle represents one data column of an array).
  % simpleScreeningFigureInfoMat contains six rows:
  % row no. 1. contains time vector
  % row no. 2. contains data vector/matrix (depending on screeningSelectParams)
  % row no. 3. contains results of Mahalanobis distance statistics
  % row no. 4. contains vector of positions (indices) of suspected samples
  % row no. 5. contains estimated critical value
  % row no. 6. contains fixed string "Time"
  simpleScreeningFigureInfoMat = [];

  while stopCrit == 0

    % inpMat sa bude postupne v kazdom cykle updatovat
    updData = inpData;
    updTime = idxTime;
    
    % outliers detection
    resStruct = mvOutlier(updData, cdfProbConstant, false);

    % data dimensions test. If screening causes the original data loss by more than 15%, then abort 
    % the outliers process and step out the function
    nRem = nRem+resStruct.nOutliers;
    decreaseFactor = 1-(nOrig-nRem)/nOrig;
    if (decreaseFactor < 0.15)

      stopCrit = 0;
    else

      stopCrit = 1;
    end

    % if no outliers detected, abort the detection process
    if (resStruct.nOutliers == 0 || stopCrit == 1)

      stopCrit = 1;
    else

      % for purpose of figure plotting
      if (screeningPlot == true)

        supportFigData = cell(6,1);
        supportFigData(1,1) = num2cell(updTime, [1,2]); % vysledny vektor indexov casu
        supportFigData(2,1) = num2cell(updData, [1,2]);
        supportFigData(3,1) = num2cell(resStruct.md2, [1,2]);
        supportFigData(4,1) = num2cell(resStruct.vecOutliersIdx, [1,2]);
        supportFigData(5,1) = num2cell(resStruct.critVal, [1,2]);
        supportFigData(6,1) = num2cell("Idx", [1,2]);

        simpleScreeningFigureInfoMat = [simpleScreeningFigureInfoMat, supportFigData]; %#ok
      end

      % inpData update. Outliers are removed form the signal
      inpData(resStruct.vecOutliersIdx, :) = [];
      idxTime(resStruct.vecOutliersIdx, :) = [];
      loopIdx = loopIdx + 1;
    end
  end

  % .summary
  scrData = inpData;

  summary = struct(...
    "nOriginal", nOrig, ... %original data dimension
    "nScreened", length(scrData), ... %screened data dimension
    "loopsNo", loopIdx, ... %number of screening cycles
    "decreasaseFactor", (nOrig-height(scrData))/nOrig, ... %data decrease factor
    "figureDataMat", num2cell(simpleScreeningFigureInfoMat, [1,2])); %figure info mat
end