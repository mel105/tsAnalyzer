% spectrogram demo. Ukazka spectrogramu
close all; 
clear variables;

% nastavenie ciest
addpath(genpath(fullfile(thisFolder, "..", "Common")));
addPaths();

%% obecne nastavenie spectrogramu
window = [];
nOverlap = [];
nFFT = [];
fs = [];
freqRange = "default";

%% PRIKLAD 1: Vygenerovanie umeleho komplexneho signalu s definovanymi frekvenciami
% Doba trvania signalu [s]
signalDur = 10;
% Sampling rate [Hz]
samplingFr = 100;
% Signal Frequency [Hz]
signalFreq = [10, 20, 30, 45];
% Signal Phase [0:2*pi]
signalPhas = [0, 0, 0, 0];
% Signal's amplitude
signalAmpl = [55, 100, 10, 20];
% Wwhite noise amplitude
wNoiseAmpl = [1, 1, 5, 1];

X = signalGenerator(signalDur, samplingFr, signalFreq, signalPhas, signalAmpl, wNoiseAmpl);
T = 0:(1/samplingFr):(samplingFr*signalDur)/samplingFr;

% spectrogram
[dataSTFT, freqVec, indCenterVec, dataPSD] = spectrogram(real(X), window, nOverlap, nFFT, samplingFr, freqRange);

% plot spectrogram
[fo] = plotSpectrogram(X, T, "sec", indCenterVec, freqVec, dataSTFT);

%% PRIKLAD 2: Data su z analyzovaneho suboru
fileName = "ALTA_meteo.txt";

% nacitanie dat a ich ulozenie do kontajnera
[data] = tsReader(fileName, false);
T = data(:,1);
X = data(:,2);

% spectrogram
[dataSTFT, freqVec, indCenterVec, dataPSD] = spectrogram(real(X), window, nOverlap, nFFT, 1, "centered");

% plot spectrogram
T = T-T(1);
[fo] = plotSpectrogram(X, T, "Sample", indCenterVec, freqVec, dataSTFT);

%% PRIKLAD 3: Data su z analyzovaneho suboru
fileName = "EMMEposuny.txt";
% nacitanie dat a ich ulozenie do kontajnera table
[data] = tsReader(fileName, true);
T = data.data(:,1);
X = data.data(:,3);
% zisti, ze ci data obsahuju nan
nanidx = find(isnan(X));
if ~isempty(nanidx)
  
  X(nanidx) = [];
  T(nanidx) = [];
end

% spectrogram
[dataSTFT, freqVec, indCenterVec, dataPSD] = spectrogram(real(X), window, nOverlap, nFFT, 1, "centered");

% plot spectrogram
[fo] = plotSpectrogram(X, T, "Sample", indCenterVec, freqVec, dataSTFT);

%% PRIKLAD 4: Data su zo suboru COST
fileName = "cost.txt";

% nacitanie dat a ich ulozenie do kontajnera table
[data] = tsReader(fileName, false);
X = data.data(:,3);
T = 1:1:length(X);
% spectrogram
[dataSTFT, freqVec, indCenterVec, dataPSD] = spectrogram(X, 200, 150, 100, 1, "twoside");

% plot spectrogram
[fo] = plotSpectrogram(X, T, "Sample", indCenterVec, freqVec, dataSTFT);