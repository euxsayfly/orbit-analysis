function eccAnom = M2EEl( ecc, meanAnom, tol, nMax )

eccAnomX  = M2EApp(ecc,meanAnom);
	

delta = tol + 1; 
n     = 0;
tau   = tol;

while ( max(abs(delta)) > tau )
  dE    	  = (meanAnom - eccAnomX + ecc*sin(eccAnomX))/ ...
                   (1 - ecc*cos(eccAnomX));
  eccAnomX    = eccAnomX + dE;
  n           = n + 1;
  delta       = norm(abs(dE),'inf');
  tau         = tol*max(norm(eccAnomX,'inf'),1.0);
  if ( nargin == 4 ),
    if ( n == nMax),
      break
    end
  end
end

eccAnom = eccAnomX;

