function [elemYDFT, elemFreq, estPerVec] = fftElemTS(elemTs, wcorr)
  % FFTELEMTS vykona to, ze kazdu jednu komponentu pretransformuje do frekvencneho spektra a vysledkom
  % je pole elemFreq, ktore ma tolko stlpcov, kolko je stlpcov elemTS

  [nRow, nCol] = size(elemTs);

  elemFreq = zeros(floor(nRow/2)+1, nCol);
  elemYDFT = zeros(floor(nRow/2)+1, nCol);
  estPerVec = zeros(1,nCol);

  for iE = 1:nCol

    curElem = elemTs(:,iE);

    nWindow = numel(curElem);

    % Hamming alebo ine filtracne okno sa pouziva k tomu, aby sa odstranil pripadny aliasing, t.j.
    % oneskorenie sa frekvencii...
    window = hamming(nWindow, 'Alpha', 0.54);
    filtElemTS = window .* curElem;
    nFiltElemTS = numel(filtElemTS);

    % .fft
    ydft = fft(filtElemTS);

    ydft = 2 * abs(ydft(1:ceil((nFiltElemTS+1)/2)));

    % frekvencie
    freq = 0:1/nFiltElemTS:1/2;

    ydft = ydft/(2*length(freq));

    elemFreq(:,iE) = freq;
    elemYDFT(:,iE) = ydft;

    % odhad najvyznamnejsej frekvencie
    locIdx = abs(complex(ydft))==max(abs(complex(ydft(2:end-1))));
    loc = (1./freq(locIdx));

    estPerVec(1,iE) = loc;
  end
end