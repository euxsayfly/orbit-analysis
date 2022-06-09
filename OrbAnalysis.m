clc;clear;
%----------------------------说明-------------------------------------%
%
% 位置向量  [Rx Ry Rz]
% 速度向量  [Vx Vy Vz]
% 
% 半长轴         (a)
% 偏心率         (e)
% 轨道倾角       (inc)
% 升交点赤径     (RAAN)
% 近地点角距       (w)
% 初始平近点角   (M0)
% 
% 蓝色区域为地球
% 绿色区域为卫星初始位置
% 红色区域为卫星在固定时间间隔的位置
% 绿色点线是卫星初始速度矢量
% 三个黑色箭头表示的是ECI
% 
%
%---------------------------------------------------------------------%

%--------------------测试用卫星状态向量--------------------------------%

%   MOLNIYA 轨道
% r = [0 -7000 -14000];
% v = [2 1 -0.5];
% vmag = 6175;


% 地球静止轨道
% r = [42241 0 0]; 
% v = [0 1 0];
% vmag = 3072;


% 极轨
% r = [42241 0 0];
% v = [0 0 1];
% vmag = 3072;


% 地偏心率地球低轨
% r = [7000 0 0];
% v = [0 1 1];
% vmag = 7500;


% 地球低轨
% r = [7000 0 0]; 
% v = [0 1 0.5];
% vmag = 7500;

% RV = [r;v];
% ELEM = RV2El(RV) 可利用该函数将上述位置速度转六要素
%-------------------------------------------------------------------%

% 仿真运行速度增加该值会增加动态绘图时间间隔
runspeed = 100;
% 仿真时间(s）
run_time = 10000;
% 初始时间
year0 = 2001;% 初始年份
month0 = 1;% 初始月份
day0 = 1;% 初始日期
hour0 = 0;% 初始时 
minute0 = 0;% 初始分 
sec0 = 0;% 初始秒
days = GetCurrentTime(00,year0,month0,day0);
% 时间
J2000_secs = days*86400 + hour0*3600 + minute0*60 + sec0; % 

% 参数设置
mu = 398.6004418e12;  % 地球引力常数，(m^3/s^2)
earth_rad = 6371000; % 地球半径，（m）
 
%--------------------初始轨道要素---------------------------------%

a = 6.915843305888847e+06; % 半长轴（in m）
e = 0.012168681444748;
inc = 0.463647609000806; % 偏心率（in rad）
RAAN = 0; % 升交点赤径（in rad）
w = pi; % 近地点角距（in rad）
M0 = pi; % 平近点角（in rad）

% 轨道周期
orbital_period = sqrt((a*a*a*4*pi*pi)/mu);
% 初始轨道根数
a_km = a/1000 % 半长轴 (in km)
b_km  = a*sqrt(1-e^2)/1000
e % 偏心率
inc_deg = inc*180/pi % 轨道倾角(in degrees)
RAAN0_deg = RAAN*180/pi; % 升交点赤径 (in degrees)
w0_deg = w*180/pi % 近地点角距 (in degrees)
M0_deg = M0*180/pi % 平近点角 (in degrees)

if (e<0)
    if (e>0.95)
        Errormsg = '偏心率大于支持值'
    end
    if (e>1)
        Errormsg = '偏心率无效'
    end
   return;
end

ELEM = [ a; e; inc; RAAN; w; M0;]; % 轨道六要素
RV = El2RV(ELEM); % 六要素转速度位置矢量
r = RV(1:3,:); % 位置矢量
V = RV(4:6,:); % 速度矢量
%---------------------静态绘图组件-----------------------%

% 初始化绘图空间
close all
set(gcf,'Menubar','default','Name','Orbit Visualization', ... 
    'NumberTitle','off','Position',[10,200,550,550], ... 
    'Color',[0.38 0.26 0.67]); 
lim=(1+e)*a;%设置图的边界
clf
axis([-lim, lim, -lim, lim, -lim, lim])	
view(150,15) 
axis equal
shg
hold on
grid on
title('卫星轨道');

% 绘制地球
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


% 绘制ECI坐标系
line([0 lim],[0 0],[0 0],'Color', 'black', 'Marker','.','LineStyle','-')
line([0 0],[0 lim],[0 0],'Color', 'black', 'Marker','.','LineStyle','-')
line([0 0],[0 0],[0 lim],'Color', 'black', 'Marker','.','LineStyle','-')

% 绘制初始向量
line([r(1) r(1)+1000*V(1)],[r(2) r(2)+1000*V(2)],[r(3) r(3)+1000*V(3)],'Color', 'green','Marker','.','LineWidth', 2, 'MarkerSize', 8,'LineStyle','-');

% 绘制初始卫星位置
plot3 (r(1), r(2), r(3),'o', 'MarkerEdgeColor', 'black','MarkerFaceColor','green','MarkerSize', 10);

%-----------------------动态绘图组件--------------------------------------%
k = 0;
long = 1:ceil(run_time/runspeed);

% 预设存储空间
Xcoord = zeros(ceil(run_time/runspeed));
Ycoord = zeros(ceil(run_time/runspeed));
Zcoord = zeros(ceil(run_time/runspeed));
lat = zeros(ceil(run_time/runspeed));

% 绘制卫星动作
Xcoord(1) = r(1);
Ycoord(1) = r(2);
Zcoord(1) = r(3);
Sun=light('Position',[1 0 0],'Style','infinite', 'Visible', 'on');

for time = 1:ceil(run_time/runspeed)
    
    k=k+1;
    % 计算偏近点角
    E=M0;
    for i=1:5
        E = E + (M0 + e*sin(E) - E)/(1 - e*cos(E));
    end
   
    % 计算真近点角
    v = 2*atan(sqrt((1+e)/(1-e))*tan(E/2));
    % 计算扁率摄动影响下的升交点赤径
    RAAN = RAAN - 10/(1-exp(1)^2)^2 * (equat_rad/a)^3.5 * cos(inc) * pi/180 * runspeed/86400;
    % 计算扁率摄动影响下的近地点角距
    w = w + 5/(1-exp(1)^2)^2 * (equat_rad/a)^3.5 * (5*cos(inc)^2-1) * pi/180 * runspeed/86400;
    % 计算极坐标下的r
    r = a*(1-e*cos(E));
    GMST = GMST + (runspeed/86400)*2*pi;
    % 计算笛卡尔坐标系下的坐标
    Xeci = r*(cos(w + v)*cos(RAAN) - sin(w+v)*sin(RAAN)*cos(inc));
    Yeci = r*(cos(w + v)*sin(RAAN) + sin(w+v)*cos(RAAN)*cos(inc));
    Zeci = r*(sin(w + v)*sin(inc));
    rotate (earth, [0 0 1], (runspeed)*(360/86400))
    rotate (Xaxis, [0 0 1], (runspeed)*(360/86400))
    rotate (Yaxis, [0 0 1], (runspeed)*(360/86400))

     
    
    % 画卫星位置 
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
    
        

     pause (0.01);% 画动态图（改为静态就注释这句）
    
    % 特殊情况
    if (sqrt (Xeci*Xeci+Yeci*Yeci+Zeci*Zeci) <= 6731000)
        blast (Xeci, Yeci, Zeci, 2000000);
        ErrorMsg = 'Blast Effected'
        break;
    end
    
    M0 = M0+sqrt(mu/(a*a*a))*runspeed; % 为下次迭代更新平近点角
   
end

%------------------显示高度范围以及轨道类型----------------%

perigee = a*(1-e);
apogee = a*(1+e);
altitude_low = (perigee-earth_rad)/1000;
altitude_high = (apogee-earth_rad)/1000;
if altitude_low>200 && altitude_high<2000
    '地球低轨'   
end
if altitude_low>2000 && altitude_high<35786
    '地球中轨'
end
if altitude_low>3786
    '地球高轨'
end
 
%---------------------绘制星下点轨迹-----------------------%
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
    
     pause (0.01);% 画动态图（改为静态就注释这句）
end
%----------------输出数据为txt-----------------%
% fid = fopen('~.txt','wt');% 写入文件路径，~处命名
% fid = mat2txt( ~,fid);% ~为输入矩阵