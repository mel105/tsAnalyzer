function window = hamming(windowLen, sflag, NameValueArgs)
  % HAMMING funkcia ocisti vstupny signal napr. o aliasing. Patri medzi tzv. vahovacie okna a
  % pouziva sa vtedy, ked je snaha potlacit vplyv postrannnych lalokov vo frekvencnych oknach. Okien
  % je cela rada, ale zbeznym prelistovanim internetu, Hammingove okno sa pouziva asi najcastiejsie.
  
  %alpha = NameValueArgs.Alpha; % 25 / 46 cca 0.54;
  alpha = NameValueArgs; % 25 / 46 cca 0.54;
  beta  = 1 - alpha;
  
  if strcmp(sflag, 'symmetric')
    
    n = 0:(windowLen-1);
    window = alpha - beta * cos(2 * pi * n / (windowLen-1)).';
  else % 'periodic'

    n = 0:windowLen;
    window = alpha - beta * cos(2 * pi * n / windowLen).';
    window = window(1:end-1);
  end
  
end