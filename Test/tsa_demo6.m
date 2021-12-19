% skript demonstruje pouzite SSA funkcie na datach ALTAposuny.txt
close all; 
clear variables;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

% nacitanie dat
fileName = "ALTAposuny.txt";

% nacitanie dat a ich ulozenie do kontajnera table
[data] = tsReader(fileName, true);

X = data.data(:,3);

% zisti, ze ci data obsahuju nan
nanidx = find(isnan(X));
if ~isempty(nanidx)

  X(nanidx) = [];
end

X = X - mean(X, 'omitnan');
X = X / std(X);

% odstranenie odlahlych hodnot
[outRes] = mvOutlier(X, 0.95, false);
X(outRes.vecOutliersIdx) = [];

% SSA
SSA(X, 'L', 260)
figure(2000); plot(X, '.')
% 
spectrogram(X)