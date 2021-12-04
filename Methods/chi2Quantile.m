function critVal = chi2Quantile(cdf, nDoF)
  % CHI2QUANTILE vrati kriticku hodnotu ch2 rozdelenia pre danu pravdepodobnost a poctu stpna
  % volnosti. Prevzata funkcia!
 
  
  if nDoF == 2
    
    critVal = -2 * log(1 - cdf);
    
  else
    
    a = nDoF;

    AA = 0.6931471806;
    C1 = 0.01;
    C2 = 0.222222;
    C3 = 0.32;
    C4 = 0.4;
    C5 = 1.24;
    C6 = 2.2;
    C7 = 4.67;
    C8 = 6.66;
    C9 = 6.73;
    C10 = 13.32;
    C11 = 60.0;
    C12 = 70.0;
    C13 = 84.0;
    C14 = 105.0;
    C15 = 120.0;
    C16 = 127.0;
    C17 = 140.0;
    C18 = 175.0;
    C19 = 210.0;
    C20 = 252.0;
    C21 = 264.0;
    C22 = 294.0;
    C23 = 346.0;
    C24 = 420.0;
    C25 = 462.0;
    C26 = 606.0;
    C27 = 672.0;
    C28 = 707.0;
    C29 = 735.0;
    C30 = 889.0;
    C31 = 932.0;
    C32 = 966.0;
    C33 = 1141.0;
    C34 = 1182.0;
    C35 = 1278.0;
    C36 = 1740.0;
    C37 = 2520.0;
    C38 = 5040.0;
    E = 0.0000005;
    IT_MAX = 20;

    xx = 0.5 * a;
    c = xx - 1.0;
  
  %  Vypocet Log ( Gamma ( A/2 ) ).
  
    g = gammaln ( a / 2.0 );
    if ( a < - C5 * log ( cdf ) )

      ch = ( cdf * xx * exp ( g + xx * AA ) )^( 1.0 / xx );

      if ( ch < E )

        critVal = ch;
        return

      end
  
    elseif ( a <= C3 )

      ch = C4;
      a2 = log ( 1.0 - cdf );

      while ( 1 )

        q = ch;
        p1 = 1.0 + ch * ( C7 + ch );
        p2 = ch * ( C9 + ch * ( C8 + ch ) );

        t = - 0.5 + ( C7 + 2.0 * ch ) / p1 ...
          - ( C9 + ch * ( C10 + 3.0 * ch ) ) / p2;

        ch = ch - ( 1.0 - exp ( a2 + g + 0.5 * ch + c * AA ) * p2 / p1 ) / t;

        if ( abs ( q / ch - 1.0 ) <= C1 )

          break;

        end

      end
    else

      x2 = normQuantile( cdf );
      p1 = C2 / a;
      ch = a * ( x2 * sqrt ( p1 ) + 1.0 - p1 )^3;
      if ( C6 * a + 6.0 < ch )

        ch = - 2.0 * ( log ( 1.0 - cdf ) - c * log ( 0.5 * ch ) + g );

      end

    end

    for i = 1 : IT_MAX

      q = ch;
      p1 = 0.5 * ch;
      p2 = cdf - gammainc( p1, xx );
      t = p2 * exp ( xx * AA + g + p1 - c * log ( ch ) );
      b = t / ch;
      a2 = 0.5 * t - b * c;

      s1 = ( C19 + a2 ...
         * ( C17 + a2 ...
         * ( C14 + a2 ...
         * ( C13 + a2 ...
         * ( C12 + a2 ...
         *   C11 ) ) ) ) ) / C24;

      s2 = ( C24 + a2 ...
         * ( C29 + a2 ...
         * ( C32 + a2 ...
         * ( C33 + a2 ...
         *   C35 ) ) ) ) / C37;

      s3 = ( C19 + a2 ...
         * ( C25 + a2 ...
         * ( C28 + a2 ...
         *   C31 ) ) ) / C37;

      s4 = ( C20 + a2 ...
         * ( C27 + a2 ...
         *   C34 ) + c ...
         * ( C22 + a2 ...
         * ( C30 + a2 ...
         *   C36 ) ) ) / C38;

      s5 = ( C13 + C21 * a2 + c * ( C18 + C26 * a2 ) ) / C37;

      s6 = ( C15 + c * ( C23 + C16 * c ) ) / C38;

      ch = ch + t * ( 1.0 + 0.5 * t * s1 - b * c ...
        * ( s1 - b ...
        * ( s2 - b ...
        * ( s3 - b ...
        * ( s4 - b ...
        * ( s5 - b ...
        *   s6 ) ) ) ) ) );

      if ( E > abs ( q / ch - 1.0 ) )

        critVal = ch;
        return

      end

    end

    critVal = ch;
    % minimalizacia rel. chyby neprebehla.
  end
end