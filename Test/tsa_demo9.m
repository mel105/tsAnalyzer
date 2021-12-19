% skript demonstruje pouzite SSA funkcie. SSA metoda je testovana na realnycha s datach danych z
% numerickeho modelu pocasia a s rozlisenim 8 hodin.

close all; 
clear variables;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

% nazov analyzovaneho suboru
fileName = "nwm.txt";

% nacitanie dat a ich ulozenie do kontajnera table
[data] = tsReader(fileName, false);
X = data(:,1);

% spracovanie casovej rady
% odstranenie priemeru a normalizacia na std = 1
X = X - mean(X);
X = X / std(X);

% SSA
SSA(X, 'L', 365)
figure(2000); plot(X, '.')
% 
spectrogram(X)