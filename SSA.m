function [results] = SSA(data, varargin)
  % SSA funkcia spracuje ulohu Analyzu signularnych spekter. Na vstupe su data v podobe (N,1)
  % vektoru, kde N je pocet dat. varargin obsahuje radu parovych nastaveni: L - je parameter (v 
  % literature sa oznacuje pismenom L), ktory definuje sirku projekcnej matice. recoModel (temporary)
  % je parameter, ktoreho volba definuje postup, ktorym chcem vykonat rekonstrukciu signalu (venoval)
  % som sa styrom, zrejme to zredukujem len na jeden postup (vec rekonstrukcie signalu je na na cely
  % vyskum :-D). Parameter seasModels (defaultne 2) charakterizuje pocet sezonnych zloziek, ale
  % zrejme ho odstranim a casom bude nepotrebny. Dovod je ten, ze som sa snazil odhad zloziek nejak
  % zautomatizovat.
  %
  % REFERENCES
  %
  % [1] Golyandina, N., V. Nekrutkin and A. Zhigljavsky (2001): Analysis of Time Series Structure: 
  % SSA and related techniques
  % [2] Hassani, Mahmoudvand (2018). Singular Spectrum Analysis. Using R.
  % [3] Golyandina, N., A. Korobeynikov and A. Zhigljavsky (2018): Singular Spectrum Analysis with R
  % [4] Kalantari, M., H. Hassini (2019). Automatic Grouping in Singular Spectrum Analysis
  % [5] Hassani, H. (xxxx). A Brief Introduction to Singular Spectrum Analysis
  % [6] Elsner, J., B., A., A., Tsonis (1996). Singular Spectrum Analysis. A new tool in time series
  % analysis
  
  % kontrola, ze ci kontajner data nie je prazdna mnozina
  assert(~isempty(data), "Na vstupe nie su ziadne data");
  
  N = length(data);
  assert(N>3, "Nevhodna dimenzia vstupnych dat");

  % default nastavenie
  L = ceil(N/2)-1;
    
  % parser a kontrola parametrov a prevzatie nastavenia
  iVar = 1;
  while iVar <= length(varargin)

    if ischar(varargin{iVar})

      if varargin{iVar} == "L"

        L = varargin{iVar+1};
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
  plotTrajectoryMatrix(X);
  
  % Singularny rozklad
  %[U, S, V] = singularValueDecomposition(X);
  % X=U*S*V'
  % U je unitarna matica (U^-1=U^H, -> U^H U=UU^H =I kde U^H= U^T)
  % V je unitarna matca
  % S je nulova (skoronulova) matica az na diagonalu, kde su nezaportne cisla a hodnoty na diagonale
  % sa nazyvaju signularne hodnoty.
  [U, S, V] = singularValueDecomposition(X);
  plotSingularValues(S);

  % Grupovanie
  [princCompTS, wcorrMatrix] = grouping(U, S, V, L, K, N);
  plotWCorrelationMatrix(wcorrMatrix);
  plotPrincipalComponents(princCompTS);

  [elemYDft, elemFreq, estPerVec] = fftElemTS(princCompTS);
  plotPCvsFreq(princCompTS, elemYDft, elemFreq, estPerVec);
 
  % Rekonstrukcia, resp. odhad trendu, sezonnych komponent a residua
  [LT, ST, R] = reconstruction(data, princCompTS, wcorrMatrix, estPerVec);
  plotTrends(data, LT, ST, R)

  % Vysledky
  results = struct(...
    "longTerm", LT, ...
    "seasonalTerm", ST, ...
    "residuals", R);
end