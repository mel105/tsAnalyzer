% tsa demo 2: Umely signal, ale trend je exponencialny
clear variables;
close all;

% vygenerovanie signalu
t = (1:340)';
trend = exp(t/100);
period1 = 17;
period2 = 10;
seasonal1 = sin(2*pi*t/period1);
seasonal2 = 0.5*sin(2*pi*t/period2);
noise = 2*(randn(length(t),1) - 0);

signalVec = trend + seasonal1 + seasonal2 + noise;

signalVec = signalVec - mean(signalVec);
signalVec = signalVec / std(signalVec);


%
SSA(signalVec, 'L', 20);



