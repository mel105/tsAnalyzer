function [set] = setting()
set = struct();

% nazov analyzovaneho suboru
set.fileName = "ALTA_meteo.txt";

% vloz premenne
set.varNames = ["Time","T","X","P"];

end