% skript demonstruje pouzite tsa.m funkcie
close all; 
clear variables;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

% nazov analyzovaneho suboru
fileName = "ALTA_meteo.txt";

% nacitanie dat a ich ulozenie do kontajnera table
[data] = tsReader(fileName, false);
X = data(:,2);
% spracovanie casovej rady
% odstranenie priemeru a normalizacia na std = 1
X = X - mean(X);
X = X / std(X);

% matlabovska funkcia R2021b
[LT,ST,R] = trenddecomp(X);
figure; plot([X LT ST R]);
legend("Data","Long-term","Seasonal1","Seasonal2","Remainder")


SSA(X, "L", 365)