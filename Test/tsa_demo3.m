% tsa demo 3. Priklad je zo stranky:
% https://www.mathworks.com/matlabcentral/fileexchange/58967-singular-spectrum-analysis-beginners-guide
close all;
clear variables;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

% nastavenie prikladu
L = 30;    % window length = embedding dimension
N = 200;   % length of generated time series
T = 22;    % period length of sine function
stdnoise = 1; % noise-to-signal ratio

t = (1:N)';
X = sin(2*pi*t/T);
noise = stdnoise*randn(size(X));
X = X + noise;
X = X - mean(X);            % remove mean value
X = X/std(X,1); 

% SSA
SSA(X, 'L', L)