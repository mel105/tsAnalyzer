function [LT, ST, R] = reconstruction(inpData, elemTS, wcorr, estPerVec) 
  % RECONSTRUCTION vrati tri zakladne zlozky: dlhodoby trend, sezonne trendy a reziduum, cize sum.
  % Tieto zlozky su pocitane automaticky bez nutnosti vyberat si nejake hlavne komponety. Postup je 
  % taky, ze trendova zlozka je odhanduta na zaklade FFT a potom odhadu dlhych frekvencii. A k 
  % sezonnym trendom sa pouzije len prvy riadok w correlation matice. Tam su pocitane korelacie
  % ostatnych komponet voci prvej komponente. Hodnoty za zgrupuju do nejakych celkov a tie
  % komponenty, sortovane do clustrov, tie sa scitaju do sezonnej zlozky. Residuum je potm pocitane
  % ako rozdiel trendu a sezonnych zloziek od vstupnych dat.

  % kluc k parsrovaniu komponent zrejme bude v clustrovani w korelacii, ale mozno by mi na vstupe do
  % funkcie postacil len prvy riadok matice
  % Tu by isla funkcia, nieco ako gruping
  % a. v riadku identifikujem komponenty, ktore budu repezentovat trend LT
  maxf = max(estPerVec);
  limitMaxf = 0.9*maxf;
  maxfidx = estPerVec > limitMaxf;
  LT = sum(elemTS(:,maxfidx),2);

  % vezmem si prvy riadok wcorr matice a odstanim z neho korelacie, ktore by odpovedali trendu
  wline = wcorr(1,:);
  wline(maxfidx) = [];
  elemTS(:,maxfidx) = [];

  if ~isempty(wline)

    if (length(wline)<=2)
      
      cidx = num2cell([1:length(wline)]);
    elseif (length(wline)>2 && length(wline)<=5)

      [clusters,cidx, ccenters] = kMeansClustering(wline', 2, 5);
    elseif (length(wline)>5 && length(wline) < 15)

      [clusters, cidx, ccenters] = kMeansClustering(wline', 4, 5);
    else

      [clusters, cidx, ccenters] = kMeansClustering(wline', 7, 5);
    end

    nSeas = length(cidx);
    ST = zeros(size(elemTS,1), nSeas);

    for i = 1:nSeas
      ST(:,i) = sum(elemTS(:,cidx{i}),2);
    end
  else
    
    % ziadna sezonna zlozka nebola identifikovana
    ST = zeros(size(elemTS,1), 1);
  end

  R = inpData - sum(ST,2) - LT;
end