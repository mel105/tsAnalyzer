function [LT, ST, R] = reconstruction(inpData, wCorrStruct, clusterStruct, estPerVec, SCA) 
  % RECONSTRUCTION vrati tri zakladne zlozky: dlhodoby trend, sezonne trendy a reziduum, cize sum.
  % Tieto zlozky su pocitane automaticky bez nutnosti vyberat si nejake hlavne komponety. Funkcia
  % obsahuje styri postupy, z ktorych by som do buducna preferoval ten stvrty. V nom je trendova
  % zlozka odhanduta na zaklade FFT a odhadu dlhych frekvencii. A k sezonnym trendom sa pouzije len
  % prvy riadok w correlation matice. Tam su pocitane korelacie ostatnych komponet voci prvej
  % komponente. Hodnoty za zgrupuju do nejakych celkov a tie komponenty, sortovane do clustrov, tie
  % sa scitaju do sezonnej zlozky. Residuum je potm pocitane ako rozdiel trendu a sezonnych zloziek
  % od vstupnych dat.

  % prevzatie niektorych premennych
  seasMatrix = wCorrStruct.seasMatrix;
  clusterCenters = clusterStruct.clusterCenters;
  numST = wCorrStruct.numST;
  elemTS = wCorrStruct.elemTS;
  wcorr = wCorrStruct.Wcorr;

  N = length(inpData);

  % trendova zlozka bude vacsinou prva komponenta a ktora sa v matici U vyskytuje najmenej
  grpLT = wCorrStruct.minFreqIdx;

  % Tento konstrukt nemusi byt uplne dobry, pretoze moze poskodit vyznamne sezonne zlozky. Ale nemam
  % to otestovane. Ale zmysel je ten, ze ak sa v seasMatrix vyskytuje riadok, ktory na pozicii 3 a 4
  % obsahuje index grpLT (prvadepodobne jedna - co znaci trend), tak tie vyznamne komponenty pri
  % jednicke scitam a robustnejsiu trendovu komponentu (moze predsa obsahovat aj menej vyznamne
  % periodicke zlozky). V zavislosti na type signalu MOZNO moze nastat situacia, ze do trendu
  % zamotam aj hlavn sezonnu zlozku. K diskusii potom je, ze ci to takto dava zmysel.
  [rlt, clt] = find(seasMatrix(:,3:4) == grpLT); clt = clt+2;

  if ~isempty(clt)

    for i=1:length(clt)
    
      if (clt(i) == 4)
      
        grpLT = [grpLT; seasMatrix(rlt, clt(i)-1)];
      else
        
        grpLT = [grpLT; seasMatrix(rlt, clt(i)+1)];
      end
    end

    seasMatrix(rlt, :) = [];
  end

  % vsetky komponenty, ktore by mali ist do trendu
  grpLT = unique(grpLT);

   % long term zlozka, resp. trend bude pozostavat min. z jednej vyznamnej komponenty.
  LT = sum(elemTS(:,grpLT),2);
  
  [sortedClusterCenters, sortedClusterIdxs] = sort(clusterCenters, 'descend');

  if (numST > (size(elemTS,2)-length(grpLT)))

    numST = size(elemTS,2)-length(grpLT);
  end

  ST = zeros(N,numST);

  % redukovanie clustrov (samostatna funkcia). Zmysel je ten, aby som pre kazdy cluster vybral len
  % unikatny vyznamny komponent. Aby sa mi komponenty v zostavovani rekonstruovaneho signalu
  % neopakovali.
  [reducedSeasMatrix, seasMatrixOmmitnans] = processClustres(seasMatrix);

  switch SCA

    case "v1"

      % tento pristup fuzovania vyznamnejsich periodickych sezonnych komponent je zalozeny na tom, ze na
      % zakladne w-korelacie a nasledneho clustrovania vytipujem signaly, ktore hodnotou korelacie su si
      % podobne a tie scitam. Ono to trocha postrada zmysel, ale hlavny point je v tom, ze ak niektore
      % komponenty analyzovanej rady medzi sebou koreluju (t.j. >> 1 - komponenty su ortogonalne a to
      % signalizuje silne harmonicike komponenty), potom ich prehlasim za vyznamne a zrejme ma zmysel
      % ich scitat a dostanem tak jednu velku sezonnu rekonstruovanu radu.
      for j = 1:numST

        clusterID = sortedClusterIdxs(j);
        [uniqClusters, iu, ic] = unique(seasMatrixOmmitnans(:,1));

        % overenie toho, ci ID clustru sa nachadza medzi unikatnimi
        ui = find(uniqClusters == clusterID,1);

        if(~isempty(ui))
          si = seasMatrixOmmitnans(:,1) == clusterID;
          PCIDX = sort([seasMatrixOmmitnans(si,3); seasMatrixOmmitnans(si,4)]);

          ST(:,j) = sum(elemTS(:,PCIDX),2);
        end
      end

    case "v2"
      
      % tento postup jednoducho najde prvu vyznamnu w korelaciu, resp. komponenty Fi, Fj medzi ktorymi
      % ktorymi vyznamna korelacia existuje a tieto dve komponenty mi vydefinuju prvu a druhu sezonnu
      % zlozku.
      srtSeasMatrix = sortrows(seasMatrixOmmitnans,2, 'descend');
      sigCmp = srtSeasMatrix(:,3:4);
      srtSigCmp = [];
      for isig = 1:size(sigCmp,1)
        srtSigCmp = [srtSigCmp; sort(sigCmp(isig,:))'];
      end

      % Dalsia kontrola. Ak zistim, ze v grpLT uz mam hore definovane nejake vyznamne komponenty, ktore
      % sa nachadzaju aj vo vektore srtSigCmp, potom zo srtSigCmp ich vymazem.
      %grpLT = unique(grpLT);
      [cmnSigCmp, idxSigCmp] = intersect(srtSigCmp, grpLT);
      if ~isempty(cmnSigCmp)
        srtSigCmp(idxSigCmp) = [];
      end

      [rsf] = restComponents(reducedSeasMatrix, [grpLT;srtSigCmp], true);
      % ak najdem este zaujimave komponenty, update srtSigCmp kontajnera.
      if ~isempty(rsf)
        srtSigCmp = sort([srtSigCmp; rsf]);
      end

      % kontrola: Ak pocet pozadovanych ST je > nez pocet vyznamnych a identifikovanych, potom zahlasim
      % warning a numST upravym podla dlzky srtSigCmp
      if ~isempty(srtSigCmp)

        if numST > length(srtSigCmp)

          warning("Maximal number of seasonal trends is %4.0f", length(srtSigCmp));
          numST = length(srtSigCmp);
          ST = [];
          ST = zeros(size(elemTS,1), numST);
        end

        for j = 1:numST
          ST(:,j) = elemTS(:,srtSigCmp(j,1));
        end
      else

        % ak som sa dostal do tejto casti kodu, zrejme nastala taka situacia, ze v anal signale sa
        % nam nepodarilo identifikovat vyznamnu sezonnu komponentu. Skusime teda este prehliadat
        % zvysne komponenty v reducetSeasMatrix, ktore sme ignorovali a zistit, ze ci sa tam nejaka
        % mala periodicka frekvencia nenachadza. Ak hej, tak vypisem warning, ze nic velkeho sme
        % nenasli, ale ze ponukame tuto zvysnu periodicku komponentu
        warning("Significant seasonal component could not be identified. The analysed signal is " + ...
          "probably not seasonal, or the main periodic cycles have insignificant representation " + ...
          "in the signal");

        [sf] = restComponents(reducedSeasMatrix, grpLT, false);

        
        if ~isempty(sf)

          warning("The remaining periodic component was found in the signal");
          ST = sum(elemTS(:,sf),2);
        else

          warning("Periodic component was not found");

          allElems = size(elemTS, 2);

          [restElems,resElemsIdx] = intersect([1:allElems]', grpLT);
          restElems = [1:1:allElems]';

          if ~isempty(resElemsIdx)
            restElems(resElemsIdx) = [];
          end

          if(size(ST,2)~=length(restElems))
            ST = zeros(size(ST,1), length(resElems));
          end

          ST = sum(elemTS(:,restElems),2);

        end
      end

    case "v3"
      % tento case je najprimitivnejsi a mozno aj najlepsi. Trend je vzdy prvy komponent a
      % periodicke su tie, ktore sme identifikovali v elemTS

      if numST > length(elemTS)-1
        numST =  length(elemTS)-1;
      end

      for j = 2:numST+1
        ST(:,j) = elemTS(:,(j));
      end

    case "v4"

      % kluc k parsrovaniu komponent zrejme bude v clustrovani w korelacii, ale mozno by mi na vstupe do
      % funkcie postacil len prvy riadok matice
      % Tu by isla funkcia, nieco ako gruping
      % a. v riadku identifikujem komponenty, ktore budu repezentovat trend LT
      maxf = max(estPerVec);
      limitMaxf = 0.9*maxf;
      maxfidx = estPerVec > limitMaxf;
      %LTidx = maxfidx; %  indexy v tomto vektore reprezentuju tie, z ktorych sa zrekonstruuje trend
      LT = sum(elemTS(:,maxfidx),2);

      % vezmem si prvy riadok wcorr matice a odstanim z neho korelacie, ktore by odpovedali trendu
      wline = wcorr(1,:);
      wline(maxfidx) = [];
      elemTS(:,maxfidx) = [];

      if (length(wline)<=5)

        [clusters,cidx, ccenters] = kMeansClustering(wline', 2, 1);
      elseif (length(wline)>5 && length(wline) < 15)

        [clusters, cidx, ccenters] = kMeansClustering(wline', 4, 1);
      else

        [clusters, cidx, ccenters] = kMeansClustering(wline', 7, 1);
      end

      nSeas = length(cidx);
      ST = zeros(size(elemTS,1), nSeas);

      for i = 1:nSeas
        ST(:,i) = sum(elemTS(:,cidx{i}),2);
      end

    otherwise
      error("Required seasonal components processing is not supported.");
  end

 
  R = inpData - sum(ST,2) - LT;
end