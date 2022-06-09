function nu = M2NuPb( meanAnom )

bo2       = 1.5*meanAnom;
oneThird  = 1/3;
d         = sqrt(1+bo2^2);
x         = (bo2+d)^oneThird - (abs(bo2-d))^oneThird;
nu        = 2*atan(x);


