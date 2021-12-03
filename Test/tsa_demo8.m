% tsa demo 8: Umely signal, zvolene periody
clear variables;
close all;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

% vygenerovanie signalu
t = (1:1000)';
trend = 0.001*(t-200).^2;
period1 = 50;
period2 = 100;
period3 = 250;
seasonal1 = 5.000*sin(2*pi*t/period1);
seasonal2 = 25.00*sin(2*pi*t/period2);
seasonal3 = 30.00*sin(2*pi*t/period3);

noise = 30*(rand(1000,1) - 0.750);

signalVec = trend + seasonal1 + seasonal2 + seasonal3 + noise;

%figure; plot(signalVec, '-')

signalVec = signalVec - mean(signalVec);
signalVec = signalVec / std(signalVec);

% matlabovska funkcia R2021b
%[LT,ST,R] = trenddecomp(signalVec);
%figure; plot([signalVec LT ST R]);
%legend("Data","Long-term","Seasonal1","Seasonal2","Remainder")

% nasa funkcia
SSA(signalVec, 'L', 100);