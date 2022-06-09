function eccAnom  = M2E( e, meanAnom, tol, nMax )

eccAnom = 0;

if( e < 1 )
    eccAnomX = M2EEl(e,meanAnom,tol,nMax);
    eccAnom = eccAnomX;
end

% Hyperbola
%----------
if( e > 1 )
    eccAnomX = M2EHy(e,meanAnom,tol,nMax);
    eccAnom = eccAnomX;
end

if( e == 1 )
  error('The eccentricity must be > 0, and not == 1');
end




