function nu = M2Nu( e, M, tol, nMax )

if( e ~= 1 )
    E = M2E( e, M, tol, nMax );
    nu = E2Nu( e, E );
else
  nu = M2NuPb( M );
end
