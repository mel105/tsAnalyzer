function [princCompTS, wcorrMatrix] = grouping(U, S, V, L, K, N)
  % GROUPING z rozkladu Henkel matice a z matice sigma S (z jej diagonaly) si vezmeme hodnoty 
  % singularnych bodov a tie nasledne normujeme. Vysledkom funkcie je tzv. w-correlation matica a
  % vektor hlavnych komponent, ale vahovane o mimodiagonalne prvky, cize v podstate uz
  % rekonstruovane. Z nich nasledne zlozime hlavne sezone a trendove veci bez nutnosti si vyberat
  % konkretne komponenty.
  
  SSV = diag(S);
  normSingVals = ((SSV.^2)./sum(SSV.^2));

  % odhad dominantych sign. values. MELTODO: tu by slo popracovat, z hodnot dominantnych values
  % vybrat na zaklade nejakeho kriteria len tie, ktore by sa uz dalej nemuseli clustrovat a ktore by
  % sa inak rozlozili na vyznamne komponenty. Napr. pomocou Mahalanobis vzdialenosti, a kvantiloveho
  % rozdelenia? Nemam to uplne premyslene, ale clustrovanie moze byti obcas komplikovane.
  nSSV = sum(normSingVals >= 0.01);

  % Vypocet hlavnych komponent uz vahovanych
  princCompTS = principalComponents(SSV, U, V, nSSV);

  % Odhad W-Correlation - vahovej korelacie
  [wcorrMatrix] = wcorrelation(princCompTS, N, L, K, nSSV);
end