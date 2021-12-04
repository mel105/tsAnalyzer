% tsa demo 2: Setreny signal je umelo generovany.
clear variables;
close all;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

% vygenerovanie signalu
t = (1:200)';
trend = 0.001*(t-100).^2;
period1 = 20;
period2 = 30;
seasonal1 = 2*sin(2*pi*t/period1);
seasonal2 = 0.75*sin(2*pi*t/period2);
noise = 2*(rand(200,1) - 0.5);

signalVec = trend + seasonal1 + seasonal2 + noise;

signalVec = signalVec - mean(signalVec);
signalVec = signalVec / std(signalVec);

% 
SSA(signalVec, 'L', 20);