clc;clear;
%----------------------------˵��-------------------------------------%
%
% λ������  [Rx Ry Rz]
% �ٶ�����  [Vx Vy Vz]
% 
% �볤��         (a)
% ƫ����         (e)
% ������       (inc)
% ������ྶ     (RAAN)
% ���ص�Ǿ�       (w)
% ��ʼƽ�����   (M0)
% 
% ��ɫ����Ϊ����
% ��ɫ����Ϊ���ǳ�ʼλ��
% ��ɫ����Ϊ�����ڹ̶�ʱ������λ��
% ��ɫ���������ǳ�ʼ�ٶ�ʸ��
% ������ɫ��ͷ��ʾ����ECI
% 
%
%---------------------------------------------------------------------%

%--------------------����������״̬����--------------------------------%

%   MOLNIYA ���
% r = [0 -7000 -14000];
% v = [2 1 -0.5];
% vmag = 6175;


% ����ֹ���
% r = [42241 0 0]; 
% v = [0 1 0];
% vmag = 3072;


% ����
% r = [42241 0 0];
% v = [0 0 1];
% vmag = 3072;


% ��ƫ���ʵ���͹�
% r = [7000 0 0];
% v = [0 1 1];
% vmag = 7500;


% ����͹�
% r = [7000 0 0]; 
% v = [0 1 0.5];
% vmag = 7500;

% RV = [r;v];
% ELEM = RV2El(RV) �����øú���������λ���ٶ�ת��Ҫ��
%-------------------------------------------------------------------%

% ���������ٶ����Ӹ�ֵ�����Ӷ�̬��ͼʱ����
runspeed = 100;
% ����ʱ��(s��
run_time = 10000;
% ��ʼʱ��
year0 = 2001;% ��ʼ���
month0 = 1;% ��ʼ�·�
day0 = 1;% ��ʼ����
hour0 = 0;% ��ʼʱ 
minute0 = 0;% ��ʼ�� 
sec0 = 0;% ��ʼ��
days = GetCurrentTime(00,year0,month0,day0);
% ʱ��
J2000_secs = days*86400 + hour0*3600 + minute0*60 + sec0; % 

% ��������
mu = 398.6004418e12;  % ��������������(m^3/s^2)
earth_rad = 6371000; % ����뾶����m��
 
%--------------------��ʼ���Ҫ��---------------------------------%

a = 6.915843305888847e+06; % �볤�ᣨin m��
e = 0.012168681444748;
inc = 0.463647609000806; % ƫ���ʣ�in rad��
RAAN = 0; % ������ྶ��in rad��
w = pi; % ���ص�Ǿࣨin rad��
M0 = pi; % ƽ����ǣ�in rad��

% �������
orbital_period = sqrt((a*a*a*4*pi*pi)/mu);
% ��ʼ�������
a_km = a/1000 % �볤�� (in km)
b_km  = a*sqrt(1-e^2)/1000
e % ƫ����
inc_deg = inc*180/pi % ������(in degrees)
RAAN0_deg = RAAN*180/pi; % ������ྶ (in degrees)
w0_deg = w*180/pi % ���ص�Ǿ� (in degrees)
M0_deg = M0*180/pi % ƽ����� (in degrees)

if (e<0)
    if (e>0.95)
        Errormsg = 'ƫ���ʴ���֧��ֵ'
    end
    if (e>1)
        Errormsg = 'ƫ������Ч'
    end
   return;
end

ELEM = [ a; e; inc; RAAN; w; M0;]; % �����Ҫ��
RV = El2RV(ELEM); % ��Ҫ��ת�ٶ�λ��ʸ��
r = RV(1:3,:); % λ��ʸ��
V = RV(4:6,:); % �ٶ�ʸ��
%---------------------��̬��ͼ���-----------------------%

% ��ʼ����ͼ�ռ�
close all
set(gcf,'Menubar','default','Name','Orbit Visualization', ... 
    'NumberTitle','off','Position',[10,200,550,550], ... 
    'Color',[0.38 0.26 0.67]); 
lim=(1+e)*a;%����ͼ�ı߽�
clf
axis([-lim, lim, -lim, lim, -lim, lim])	
view(150,15) 
axis equal
shg
hold on
grid on
title('���ǹ��');

% ���Ƶ���
equat_rad = 6378137.00;
    polar_rad = 6356752.3142;
    [xx ,yy, zz] = ellipsoid (0,0,0,equat_rad, equat_rad, polar_rad);
    load('topo.mat','topo','topomap1');
    topo2 = [topo(:,181:360) topo(:,1:180)];
    pro.FaceColor= 'texture';
    pro.EdgeColor = 'none';
    pro.FaceLighting = 'phong';
    pro.Cdata = topo2;
   earth = surface(xx,yy,zz,pro);
    colormap(topomap1)
omega_earth = 7.292115855377074e-005; % (rad/sec)  
Go = 1.727564365843028; % (rad)  
GMST = Go + omega_earth*(86400*0.5+J2000_secs);
GMST = GMST - 2*pi*floor(GMST/(2*pi));
GMST_deg = GMST * (180/pi);
rotate (earth, [0 0 1], GMST_deg);
Xaxis= line([0 lim],[0 0],[0 0],'Color', 'red', 'Marker','.','LineStyle','-');
Yaxis= line([0 0],[0 lim],[0 0],'Color', 'red', 'Marker','.','LineStyle','-');
rotate (Xaxis, [0 0 1], GMST_deg);
rotate (Yaxis, [0 0 1], GMST_deg);
Sun = light('Position',[1 0 0],'Style','infinite');


% ����ECI����ϵ
line([0 lim],[0 0],[0 0],'Color', 'black', 'Marker','.','LineStyle','-')
line([0 0],[0 lim],[0 0],'Color', 'black', 'Marker','.','LineStyle','-')
line([0 0],[0 0],[0 lim],'Color', 'black', 'Marker','.','LineStyle','-')

% ���Ƴ�ʼ����
line([r(1) r(1)+1000*V(1)],[r(2) r(2)+1000*V(2)],[r(3) r(3)+1000*V(3)],'Color', 'green','Marker','.','LineWidth', 2, 'MarkerSize', 8,'LineStyle','-');

% ���Ƴ�ʼ����λ��
plot3 (r(1), r(2), r(3),'o', 'MarkerEdgeColor', 'black','MarkerFaceColor','green','MarkerSize', 10);

%-----------------------��̬��ͼ���--------------------------------------%
k = 0;
long = 1:ceil(run_time/runspeed);

% Ԥ��洢�ռ�
Xcoord = zeros(ceil(run_time/runspeed));
Ycoord = zeros(ceil(run_time/runspeed));
Zcoord = zeros(ceil(run_time/runspeed));
lat = zeros(ceil(run_time/runspeed));

% �������Ƕ���
Xcoord(1) = r(1);
Ycoord(1) = r(2);
Zcoord(1) = r(3);
Sun=light('Position',[1 0 0],'Style','infinite', 'Visible', 'on');

for time = 1:ceil(run_time/runspeed)
    
    k=k+1;
    % ����ƫ�����
    E=M0;
    for i=1:5
        E = E + (M0 + e*sin(E) - E)/(1 - e*cos(E));
    end
   
    % ����������
    v = 2*atan(sqrt((1+e)/(1-e))*tan(E/2));
    % ��������㶯Ӱ���µ�������ྶ
    RAAN = RAAN - 10/(1-exp(1)^2)^2 * (equat_rad/a)^3.5 * cos(inc) * pi/180 * runspeed/86400;
    % ��������㶯Ӱ���µĽ��ص�Ǿ�
    w = w + 5/(1-exp(1)^2)^2 * (equat_rad/a)^3.5 * (5*cos(inc)^2-1) * pi/180 * runspeed/86400;
    % ���㼫�����µ�r
    r = a*(1-e*cos(E));
    GMST = GMST + (runspeed/86400)*2*pi;
    % ����ѿ�������ϵ�µ�����
    Xeci = r*(cos(w + v)*cos(RAAN) - sin(w+v)*sin(RAAN)*cos(inc));
    Yeci = r*(cos(w + v)*sin(RAAN) + sin(w+v)*cos(RAAN)*cos(inc));
    Zeci = r*(sin(w + v)*sin(inc));
    rotate (earth, [0 0 1], (runspeed)*(360/86400))
    rotate (Xaxis, [0 0 1], (runspeed)*(360/86400))
    rotate (Yaxis, [0 0 1], (runspeed)*(360/86400))

     
    
    % ������λ�� 
    array(k) = plot3 (Xeci, Yeci, Zeci,'o', 'MarkerEdgeColor', 'k','MarkerFaceColor','r','MarkerSize', 6);
    position(k) = line([0 Xeci],[0 Yeci], [0 Zeci],'Color', 'yellow', 'LineWidth', 2);
    
    if (k~=1)
    set (array(k-1), 'Visible', 'off');
    set (position(k-1), 'Visible', 'off');
    end
        
    if (time~=1 && time<=ceil(run_time/runspeed)+1)
        Xcoord(k)=Xeci;
        Ycoord(k)=Yeci;
        Zcoord(k)=Zeci;
        line([Xcoord(k-1) Xcoord(k)],[Ycoord(k-1) Ycoord(k)], [Zcoord(k-1) Zcoord(k)],'Color', 'black', 'LineWidth', 2);
    end
    
    
  
    if (GMST>2*pi)
        GMST = GMST-2*pi;
    end
    
    lat(k) = atan(Zeci/sqrt(Xeci*Xeci+Yeci*Yeci))*(180/pi);
    ECIX = [cos(GMST) sin(GMST) 0];
    Pos = [Xeci Yeci 0];
    %Posmag = sqrt(dot(Pos, Pos));
    cvec = cross(ECIX,Pos);
    angleyz = mod(sign(dot([0 0 1],cvec))*atan2(norm(cvec),dot(ECIX,Pos)),2*pi);
    long(k) = (180/pi)* angleyz;
    
        

     pause (0.01);% ����̬ͼ����Ϊ��̬��ע����䣩
    
    % �������
    if (sqrt (Xeci*Xeci+Yeci*Yeci+Zeci*Zeci) <= 6731000)
        blast (Xeci, Yeci, Zeci, 2000000);
        ErrorMsg = 'Blast Effected'
        break;
    end
    
    M0 = M0+sqrt(mu/(a*a*a))*runspeed; % Ϊ�´ε�������ƽ�����
   
end

%------------------��ʾ�߶ȷ�Χ�Լ��������----------------%

perigee = a*(1-e);
apogee = a*(1+e);
altitude_low = (perigee-earth_rad)/1000;
altitude_high = (apogee-earth_rad)/1000;
if altitude_low>200 && altitude_high<2000
    '����͹�'   
end
if altitude_low>2000 && altitude_high<35786
    '�����й�'
end
if altitude_low>3786
    '����߹�'
end
 
%---------------------�������µ�켣-----------------------%
figure (2);
set(gcf,'Menubar','none','Name','Earth Track', ... 
    'NumberTitle','off','Position',[10,200,1000,500], ... 
    'Color',[0.4 0.3 0.7]); 
hold on
image([0 360],[-90 90],topo,'CDataMapping', 'scaled');
colormap(topomap1);
axis equal
axis ([0 360 -90 90]);
% plot (167.717,8.717,'o', 'MarkerEdgeColor', 'k','MarkerFaceColor','y','MarkerSize', 10);
% plot (360-76.496, 42.440,'o', 'MarkerEdgeColor', 'k','MarkerFaceColor','y','MarkerSize', 10);

for i=1:k
    plot (long(i),lat(i),'o', 'MarkerEdgeColor', 'k','MarkerFaceColor','r','MarkerSize', 6);
    if (i~=1 && abs(long(i-1)-long(i))<100)
        line([long(i-1) long(i)],[lat(i-1) lat(i)],'Color', 'red', 'LineWidth', 2);
    end
    
     pause (0.01);% ����̬ͼ����Ϊ��̬��ע����䣩
end
%----------------�������Ϊtxt-----------------%
% fid = fopen('~.txt','wt');% д���ļ�·����~������
% fid = mat2txt( ~,fid);% ~Ϊ�������