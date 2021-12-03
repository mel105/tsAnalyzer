function [T] = embedding(data, L)
  % EMBEDDING funkcia vrati tzv. trajectory/Henkel matrix. 
  
  TH = hankel(data);
  T = TH(1:end-L+1, 1:L); T = T';
end