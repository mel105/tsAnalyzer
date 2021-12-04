% skript demonstruje pouzitie SSA metody na datach zo suboru ALTA_meteo.txt
close all; 
clear variables;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

% nazov analyzovaneho suboru
fileName = "ALTA_meteo.txt";

% nacitanie dat a ich ulozenie do kontajnera
[data] = tsReader(fileName, false);
X = data(:,2);

% spracovanie casovej rady
% odstranenie priemeru a normalizacia na std = 1
X = X - mean(X);
X = X / std(X);

%
SSA(X)