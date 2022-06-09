function E = Nu2E( e, nu )


if( e == 1 )
  error('Eccentric anomaly is not defined for parabolas')
end

E = zeros(size(e));
	
if( e < 1 )
  E = 2*atan( sqrt( (1-e)/(1+e) )*tan(0.5*nu));
end

if( e > 1 )
  E = 2*atanh( sqrt( (e-1)/(1+e) )*tan(0.5*nu)); 
end


