function y=GetCurrentTime(Year0,Year,month,date)
%�ú��������Year0��1��1��0ʱ0��0������
%Year0����λ����, ȡ��ݺ���λ.
%����������λ������50������Ϊ��19**��ģ�
%������Ϊ��20**���.
%Date, y�Ǵ�С����˫��������.
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

%�趨��������ĳ�ʼֵ.
y=0;
%�����Year0�꿪ʼ��Year���������������.
for k=Year0:1:(Year-1)
    if mod(k,4)==0  %�ж�Ϊ����.
        temp = 366;
    else
        temp = 365;
    end
    y = y + temp;
end
%�������ֵ, ��Year0��Year���date�������.
y = y +  date;