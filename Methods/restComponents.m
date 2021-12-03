function [sf] = restComponents(reducedSeasMatrix, grpKnownComponents, hRankedComponents)
  % RESCOMPONENTS vrati komponenty, ktore boli v paroch s tagom -999. Zmyslom funkcie je najst
  % pripadne komponenty, ktore su v rebricku hlavnych komponent vyznamnejsie, nez tie
  % identifikovane a z pohladu odhadu sezonnych zloziek mozu hrat vyznamnu ulohu.

  sf = [reducedSeasMatrix(:,3); reducedSeasMatrix(:,4)];
  sf999 = find(sf==-999);
  if ~isempty(sf999)
    sf(sf999) = [];
  end
  [csc, idxcsc] = intersect(sf, grpKnownComponents);

  if ~isempty(csc)

    sf(idxcsc) = [];
  end

  % ak by nastala chyba. Zmyslom tejto casti je vytipovat len tie komponenty, ktore su mensie, nez
  % uz tie, v grpKnownComponents
  if hRankedComponents
    minCmpNumber = min(grpKnownComponents);

    idx = sf<minCmpNumber;
    sf = sf(idx);

  else
    %
  end
end