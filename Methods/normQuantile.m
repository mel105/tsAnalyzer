function value = normQuantile(p, mu, sigma)
  % NORMQUANTILE vrati kriticku hodnotu hustoty pravdepodobnosti normovaneho normalneho  
  % rozdelenia.
  
  switch nargin
    case 1
      a = [ 3.3871328727963666080,      1.3314166789178437745e+2, ...
            1.9715909503065514427e+3,   1.3731693765509461125e+4, ...
            4.5921953931549871457e+4,   6.7265770927008700853e+4, ...
            3.3430575583588128105e+4,   2.5090809287301226727e+3 ];

      b = [ 1.0,                        4.2313330701600911252e+1, ...
            6.8718700749205790830e+2,   5.3941960214247511077e+3, ...
            2.1213794301586595867e+4,   3.9307895800092710610e+4, ...
            2.8729085735721942674e+4,   5.2264952788528545610e+3 ];

      c = [ 1.42343711074968357734,     4.63033784615654529590, ...
            5.76949722146069140550,     3.64784832476320460504, ...
            1.27045825245236838258,     2.41780725177450611770e-1, ...
            2.27238449892691845833e-2,  7.74545014278341407640e-4 ];

      CONST_1 = 0.180625;
      CONST_2 = 1.6;

      d = [ 1.0,                        2.05319162663775882187,    ...
            1.67638483018380384940,     6.89767334985100004550e-1, ...
            1.48103976427480074590e-1,  1.51986665636164571966e-2, ...
            5.47593808499534494600e-4,  1.05075007164441684324e-9 ];

      e = [ 6.65790464350110377720,     5.46378491116411436990,    ...
            1.78482653991729133580,     2.96560571828504891230e-1, ...
            2.65321895265761230930e-2,  1.24266094738807843860e-3, ...
            2.71155556874348757815e-5,  2.01033439929228813265e-7 ];

      f = [ 1.0,                        5.99832206555887937690e-1, ...
            1.36929880922735805310e-1,  1.48753612908506148525e-2, ...
            7.86869131145613259100e-4,  1.84631831751005468180e-5, ...
            1.42151175831644588870e-7,  2.04426310338993978564e-15 ];

      a = fliplr(a);   b = fliplr(b);
      c = fliplr(c);   d = fliplr(d);        
      e = fliplr(e);   f = fliplr(f);        


      SPLIT_1 = 0.425;
      SPLIT_2 = 5.0;

      if ( p <= 0.0 )

        value = -1e30;
        return

      end

      if ( 1.0 <= p )

        value = 1e30;
        return

      end

      q = p - 0.5;

      if ( abs ( q ) <= SPLIT_1 )

        r = CONST_1 - q * q;
        value = q * polyval( a, r ) / polyval( b, r );

      else

        if ( q < 0.0 )

          r = p;

        else

          r = 1.0 - p;

        end

        if ( r <= 0.0 )

          value = 1e30;

        else

          r = sqrt ( -log ( r ) );

          if ( r <= SPLIT_2 )

            r = r - CONST_2;
            value = polyval( c, r ) / polyval( d, r );
          else

            r = r - SPLIT_2;
            value = polyval(e, r ) / polyval(f, r );
          end

        end

        if ( q < 0.0 )

          value = -value;

        end

      end
    case 2
      warning('Vypocet kriticke hodnoty pro nenormovane normalni rozdeleni neni prozatim implementovano.');
      value = [];
    case 3
      warning('Vypocet kriticke hodnoty pro nenormovane normalni rozdeleni neni prozatim implementovano.');
      value = [];
    otherwise
      error('Chyba');
  end

end