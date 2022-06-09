function RV = El2RV(elem)



%elem=[a;e;i;W;w;M];
%el=[a;i;W;w;e;M];
el=[elem(1);elem(3);elem(4);elem(5);elem(2);elem(6)];

%-------------------------------------------------------------------------------
%   ���Ҫ��תλ��ʸ�����ٶ�ʸ��.
%-------------------------------------------------------------------------------
%   ��ʽ:
%   [r, v] = El2RV( el, tol, mu )
%-------------------------------------------------------------------------------
%
%   ------
%   ����
%   ------
%   el              (6,:) ��Ҫ�� [a;i;W;w;e;M] (����)
%   tol             (1,1) Tolerance for Kepler's equation solver
%   mu              (1,1) Gravitational constant
%
%   -------
%   ���
%   -------
%   r               (3,:) λ��ʸ��
%   v               (3,:) �ٶ�ʸ��
%
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

mu = 3.9860044e14;
tol = 1.e-14;

%  Elements vector [a;i;W;w;e;M]
%-------------------------------
  e      = el(5);
  M      = el(6);
  a      = el(1);
  f      = M2Nu( e, M, tol, 200 );

  if( e ~= 1 )
    p    = a*(1-e)*(1+e);
  else
    p    = a*(1+e);
  end
  
  cf     = cos(f);
  sf     = sin(f);
   
  rp     = p/(1 + e*cf)*[ cf; sf; 0 ];
  vp     = sqrt(mu/p)*[-sf; e+cf; 0];
 
  c      = CP2I( el(2), el(3), el(4) );


  r = c*rp;
  v = c*vp;

RV=[r;v];
