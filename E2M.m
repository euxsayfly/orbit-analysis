function meanAnom = E2M( ecc, eccAnom )

meanAnomX = zeros(size(eccAnom));

if( ecc == 1 )
  error('Eccentric anomaly is not defined for parabolas')
end

if( ecc < 1 )
  meanAnomX = eccAnom - ecc*sin( eccAnom );
end

if( ecc > 1 )
  meanAnomX = ecc*sinh( eccAnom ) - eccAnom;
end

meanAnom = meanAnomX;




