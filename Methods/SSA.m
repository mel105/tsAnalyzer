function [results] = SSA(data, varargin)
  % SSA funkcia spracuje ulohu Analyzu signularnych spekter
  %
  % * INPUTS
  %
  % * data - analyzovany vektor dat.
  % * L - 
  % * recoIdx - index na zaklade ktoreho vyberieme pozadovane vlastne cisla a z ktorych 
  % zrekonstruujeme hlavne komponenty
  %
  % REFERENCES
  %
  % [1] Golyandina, N., V. Nekrutkin and A. Zhigljavsky (2001): Analysis of Time Series Structure: 
  % SSA and related techniques
  

  % kontrola, ze ci kontajner data nie je prazdna mnozina
  assert(~isempty(data), "Na vstupe nie su ziadne data");
  
  N = length(data);
  assert(N>3, "Nevhodna dimenzia vstupnych dat");

  % default nastavenie
  L = ceil(N/2)-1;
  recoModel = "v4";
  seasModels = 2;
  
  % parser a kontrola parametrov
  % .prevzatie nastavenia
  iVar = 1;
  while iVar <= length(varargin)

    if ischar(varargin{iVar})

      if varargin{iVar} == "L"

        L = varargin{iVar+1};
        iVar = iVar + 1;
      elseif varargin{iVar} == "recoModel"

        recoModel = varargin{iVar+1};
        iVar = iVar + 1;
      elseif varargin{iVar} == "seasModels"

        seasModels = varargin{iVar+1};
        iVar = iVar + 1;
      else

        warning('Parameter is not recognized');
        disp(varargin{iVar});
      end
    end
    iVar = iVar + 1;
  end
  
  % K
  K = N-L+1;

  % X je vysledna Henkelova matica
  [X] = embedding(data, L);
  %  plotTrajectoryMatrix(X);
  
  % singularny rozklad
  %[U, S, V] = singularValueDecomposition(X);
  % X=U*S*V'
  % U je unitarna matica (U^-1=U^H, -> U^H U=UU^H =I kde U^H= U^T)
  % V je unitrna matca
  % S je nulova matica az na diagonalu, kde su nezaportne cisla a hodnoty na diagonale sa nazyvaju
  % signularne hodnoty.
  [U, S, V] = singularValueDecomposition(X);
  %plotSingularValues(S);

  % Grupovanie
  [wcorrStruct, clusterStruct] = grouping(U, S, V, L, K, N, seasModels);
  %plotPrincipalComponents(wcorrStruct.elemTS)
  plotWCorrelationMatrix(wcorrStruct.Wcorr)
  %plotWCorrTril(wcorrStruct.Wcorr)
  plotPrincipalComponents(wcorrStruct.elemTS)

  [elemYDft, elemFreq, estPerVec] = fftElemTS(wcorrStruct.elemTS, wcorrStruct.Wcorr);
  plotPCvsFreq(data, wcorrStruct.elemTS, elemYDft, elemFreq, estPerVec);
 
  % Rekonstrukcia, resp. odhad trendu, sezonnych komponent a residua
  [LT, ST, R] = reconstruction(data, wcorrStruct, clusterStruct, estPerVec, recoModel);
  plotTrends(data, LT, ST, R)

  results = struct(...
    "longTerm", LT, ...
    "seasonalTerm", ST, ...
    "residuals", R);
  
end