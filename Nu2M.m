function [meanAnom,eccAnom] = Nu2M( e, nu )

if( e ~= 1 )
  eccAnom  = Nu2E( e, nu );
  meanAnom = E2M( e, eccAnom );
else
  eccAnom = 0;
  meanAnom = tan(0.5*nu) + tan(0.5*nu).^3/3;
end



