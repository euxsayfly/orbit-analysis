function y=GetCurrentTime(Year0,Year,month,date)
%该函数计算从Year0年1月1日0时0分0秒起算
%Year0是两位整数, 取年份后两位.
%如果这个两个位数大于50，则认为是19**年的，
%否则认为是20**年的.
%Date, y是带小数的双精度数据.
switch month
    case 1
        date = date;
    case 2
        date = 31 + date;
    case 3
        if mod(Year,4)==0
            date = 60 + date;
        else
            date = 59 + date;
        end
    case 4
        if mod(Year,4)==0
            date = 91 + date;
        else
            date = 90 + date;
        end
    case 5
        if mod(Year,4)==0
            date = 121 + date;
        else
            date = 120 + date;
        end
    case 6
        if mod(Year,4)==0
            date = 152 + date;
        else
            date = 151 + date;
        end
    case 7
        if mod(Year,4)==0
            date = 182 + date;
        else
            date = 181 + date;
        end
    case 8
        if mod(Year,4)==0
            date = 213 + date;
        else
            date = 212 + date;
        end
    case 9
        if mod(Year,4)==0
            date = 244 + date;
        else
            date = 243 + date;
        end
    case 10
        if mod(Year,4)==0
            date = 274 + date;
        else
            date = 273 + date;
        end
    case 11
        if mod(Year,4)==0
            date = 305 + date;
        else
            date = 304 + date;
        end
    case 12
        if mod(Year,4)==0
            date = 335 + date;
        else
            date = 334 + date;
        end
end

          date = date-1;

if Year0>50
    Year0 = 1900 + Year0;
else
    Year0 = 2000 + Year0;
end

%设定输出函数的初始值.
y=0;
%计算从Year0年开始到Year年的正年数的天数.
for k=Year0:1:(Year-1)
    if mod(k,4)==0  %判断为闰年.
        temp = 366;
    else
        temp = 365;
    end
    y = y + temp;
end
%计算输出值, 从Year0到Year年第date天的天数.
y = y +  date;