function [] = addPaths()
  % ADDPATHS nastavi cesty k lokalnym adresarom
  addpath(genpath(fullfile("..")));  
  addpath(genpath(fullfile("..", "Data")));
  addpath(genpath(fullfile("..", "Methods")));
  addpath(genpath(fullfile("..", "Sinks")));
  addpath(genpath(fullfile("..", "Support")));
end