function nu = E2Nu( e, E )

if( e == 1 )
  error('Eccentric anomaly is not defined for parabolas')
end

nuX = zeros(size(E));

if( e < 1 )
  nuX = 2*atan(sqrt((1+e)/(1-e))*tan(0.5*E));
end

if( e > 1 )
  nuX = 2*atan(sqrt((1+e)/(e-1))*tanh(0.5*E));
end

nu = nuX;


