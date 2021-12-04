function [mainComponentsTS] = principalComponents(s,U,V,M)
  % PRINCIPALCOMPONENTS Odhadne hlavne komponenty. Vysledkom je pole elemTS, ktore obsahuje tolko
  % stlpcov, kolko je pocet vyznamnych hlavnych komponent. Hlavne komponenty su vahovane
  % antidiagonalami a teda vysledkom su uz rekonstruovane komponety

  L = size(U,1);
  K = size(V,1);
  N = K + L - 1;
  
  mainComponentsTS = zeros(N,M);
  numAntiDiag = K+min(1-K:L-1,0)+min(L-1:-1:1-K,0);
  for j = 1:M
    
    mainComponentsTS(:,j) = s(j)*conv(U(:,j), V(:,j))./numAntiDiag.';
  end
end
