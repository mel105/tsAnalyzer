% tsa demo 2: Umely signal
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

%figure; plot(signalVec, '-')

signalVec = signalVec - mean(signalVec);
signalVec = signalVec / std(signalVec);

% matlabovska funkcia R2021b
[LT,ST,R] = trenddecomp(signalVec);
figure; plot([signalVec LT ST R]);
legend("Data","Long-term","Seasonal1","Seasonal2","Remainder")

% nasa funkcia
SSA(signalVec, 'L', 20);