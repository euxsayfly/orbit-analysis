function elem = RV2El(RV)
%


%-------------------------------------------------------------------------------
%   状态量转六要素
%-------------------------------------------------------------------------------
%  格式:
%   [el, E, f] = RV2El( r, v, mu )
%-------------------------------------------------------------------------------
%
%   ------
%   输入
%   ------
%   r               (3,1) 位置矢量
%   v               (3,1) 速度矢量
%   mu              (1,1) 引力常数
%
%   -------
%   输出
%   -------
%   el              (1,6) 六要素[a,i,W,w,e,M]
%   E               (1,1) 偏近点角
%   f               (1,1) 真近点角
%

%-------------------------------------------------------------------------------
r=RV(1:3,1);
v=RV(4:6,1);

mu = 3.9860044e14;

el = zeros(1,6);

% 公差
%------------
tol  = 1.e-12;

% 角动量
%---------------------------
h    = cross(r,v);
	
n    = cross( [0;0;1], h );

nMag = Mag( n );
hMag = Mag( h );
rMag = Mag( r );
vMag = Mag( v );
vSq  = vMag^2;
	
% 偏心率矢量
%------------------------
rV   = r'*v;
e    = ((vSq - mu/rMag)*r - rV*v)/mu;

% 六要素矢量 [a,i,W,w,e,M]
	
% 偏心率
%-----------------
el(5)  = Mag( e );

% 半长轴
%-------------------
z    = 0.5*vSq - mu/rMag;

if( el(5) ~= 1 )
  el(1) = -0.5*mu/z;
else
  el(1) = inf;
end
	
% 轨道倾角
%----------------
el(2) = acos( h(3) / hMag );

f = 0;
if( abs(el(2)) < tol && el(5) < tol ) 
	f = acos( r(1)/rMag );
	if( r(2) < 0 )
		f = 2*pi - f;
	end
	
elseif( abs(el(2)) >= tol && el(5) < tol ) 
  arg = n'*r/(nMag*rMag);
	f   = real(acos(arg));
	if( r(3) < 0 )
		f = 2*pi - f;
	end

   el(3) = acos( n(1) / nMag );
	if( n(2) < 0 )
	   el(3) = 2*pi - el(3);
	end
   
elseif( abs(el(2)) < tol || (abs(el(2) - pi) < tol) ) 
  % 升交点赤径
  %--------------------
  el(4) = acos( e(1)/ el(5) );
  if( e(2) < 0 )
		el(4) = 2*pi - el(4);
  end

else
	
   
   el(3) = acos( n(1) / nMag );
	 if( n(2) < 0 )
		 el(3) = 2*pi - el(3);
	 end
	
   arg = n'*e / ( nMag*el(5) );
	 
   if( abs(arg) > 1 )
      arg = sign(arg);
   end

   el(4) = acos(arg);

   if( e(3) < 0 )
     el(4) = 2*pi - el(4);
   end
end
	

if( el(5) > tol)
	
  % 真近点角
  %-----------------
  arg = e'*r/(rMag*el(5));

  if( abs(arg) > 1 )
    arg = sign(arg);
  end
  f = acos(arg);

  if ( rV < 0 )
    f = 2*pi - f;
  end
	  
end
	
[el(6),E] = Nu2M(el(5),f);

% if( nargout<2 )
%    return;
% end

if( f < 0 )
  f = f + 2*pi;
end

if el(5) ~= 1
  E     = Nu2E(el(5),f);
else
  E = 0;
end


% 六要素矢量 [a,i,W,w,e,M]
% elem=[a;e;i;W;w;M]
elem=zeros(6,1);
elem(1)=el(1);
elem(2)=el(5);
elem(3)=el(2);
elem(4)=el(3);
elem(5)=el(4);
elem(6)=el(6);

if elem(6)<0
    elem(6)=elem(6)+2*pi;
end


