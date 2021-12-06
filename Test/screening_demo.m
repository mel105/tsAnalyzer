% skript demonstruje pouzitie  metody na odhad vzoriek podozrivych z odlahlosti.
close all; 
clear variables;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

% nacitanie dat
fileName = "EMMEposuny.txt";

% nacitanie dat a ich ulozenie do kontajnera table
[data] = tsReader(fileName, true);

distortedData = data.data(:, 5);

% zisti, ze ci data obsahuju nan
nanidx = find(isnan(distortedData));
if ~isempty(nanidx)

  distortedData(nanidx) = [];
end

% Screening
[screenedData, screeningSummary] = screening(distortedData, 0.9, true);

[foOrig, foHeigh, foScreen, foOutMat] = plotScreening(distortedData, screenedData, screeningSummary);

% show plots
figure(foOrig);
figure(foHeigh);
figure(foScreen);

for i = 1:size(foOutMat,1)

  figure(foOutMat(i,1));
  figure(foOutMat(i,2));
end
