function eccAnom = M2EApp( e, meanAnom )


if any( e < 0 | e == 1 )
  error('The eccentricity must be > 0, and not == 1');
end

  eccAnomX = 0;
 
  if(meanAnom ~= 0)
   m    = meanAnom;
   if(m > pi)
       m = -m;           
   end
 
  if( e < 1 )     % elliptical case.
    sM      = sin(m); 
    eA = m + e*sM/(1 - sin(m+e) + sM);
  else  
    sM     = sinh(m/(e-1));
    eA = m^2/ (e*(e-1)*sM - m);
  end
  
  if( m > pi )
    eA = -eA;
  end
  
  eccAnomX = eA;
  
  end
  
  eccAnom = eccAnomX;



