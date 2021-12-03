function [data] = tsReader(fileName, mHeader)
  % TSREADER nacita pozadovany subor. Ten sa nastavil v Test/setting();

  filePath = fullfile(fileparts(cd), "Data", fileName);
  if mHeader
    data = importdata(filePath, ' ', 1);
  else
    data = importdata(filePath);
  end

  %{
  dataTab = readtable(filePath);
  if any(strcmp(dataTab.Properties.VariableNames, "Var1"))
    dataTab.Properties.VariableNames = cfg.varNames;
  end
  %}
end