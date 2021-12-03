function [sm, smon] = processClustres(seas)

  idxVec = [seas(:,3); seas(:,4)];
  [C,ia,ic] = unique(idxVec);

  a_counts = accumarray(ic,1);

  sm = seas;
  smon = seas;
  aidx = a_counts==1;
  value_counts = [C, a_counts];

  % tie indexy, ktorych a_counts == 1, tie ma nezaujimaju
  value_counts(aidx, :) = [];

  if size(value_counts,1) ~= 0

    for iV = 1:size(value_counts,1)

      currVal = value_counts(iV);
      [a, b] = find(sm(:,3:4)==currVal);
      [currMax, posInA] = max(sm(a,2));
      a(posInA) = [];
      b(posInA) = []; b = b + 2;

      sm(a, b) = -999;

    end
  end

  idxcounter = 1;
  rowidx = [];
  for i = 1:size(sm,1)
    if sm(i,3)==-999 || sm(i,4)==-999
      rowidx = [rowidx; idxcounter];

    end
    idxcounter = idxcounter+1;
  end
  smon(rowidx,:) = [];
end