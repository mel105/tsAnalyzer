function OUT = mytimes(A,B)

  [m1,n1] = size(A);
  [m2,n2] = size(B);
  OUT = repmat(A,m2,n2).*repmat(B,m1,n1);
end