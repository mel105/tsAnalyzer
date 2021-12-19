% skript demonstruje pouzite SSA funkcie na datach EMMEposuny.txt. Funkcia tiez demonstruje
% predpspracovanie dat v zmysle identifikacie vzoriek podozrivych z odlahlosti. Tu este popracujem
% na tom, aby funkcia na odhad odlahlych hodnot pracovala iterativne. A dolezite je ocistit maticu
% dat o hodnoty nan;
close all; 
clear variables;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

% nacitanie dat
fileName = "EMMEposuny.txt";

% nacitanie dat a ich ulozenie do kontajnera table
[data] = tsReader(fileName, true);

X = data.data(:,3);

% zisti, ze ci data obsahuju nan
nanidx = find(isnan(X));
if ~isempty(nanidx)

  X(nanidx) = [];
end

% odsranenie odlahlych merani
%[resOut] = mvOutlier(X, 0.9, true);
%X(resOut.vecOutliersIdx) = [];
%[X, screeningSummary] = screening(X, 0.9, true);

X = X - mean(X, 'omitnan');
X = X / std(X);

% SSA
SSA(X, 'L', 365)
figure(2000); plot(X, '.')
% 
spectrogram(X)