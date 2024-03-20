function doy = dayOfYear(year, month, day)

if month == 1
    doy = day;
elseif month == 2
    doy = 31 + day;
elseif month == 3
%     if mod(year,4) == 0
%         doy = 31+29+day;
%     else
        doy = 31+28+day;
%     end
elseif month == 4
    doy = 31 +28 + 31+ day;
elseif month == 5
    doy = 31 +28 + 31+ 30 + day;
elseif month == 6
    doy = 31 +28 + 31+ 30 + 31 + day;
elseif month == 7
    doy = 31 +28 + 31+ 30 + 31 + 30 + day;
elseif month == 8
    doy = 31 +28 + 31+ 30 + 31 + 30 + 31 + day;
elseif month == 9
    doy = 31 +28 + 31+ 30 + 31 + 30 + 31 + 31 + day;
elseif month == 10
    doy = 31 +28 + 31+ 30 + 31 + 30 + 31 + 31 + 30 + day;
elseif month == 11
    doy = 31 +28 + 31+ 30 + 31 + 30 + 31 + 31 + 30 + 31 + day;
elseif month == 12
    doy = 31 +28 + 31+ 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30 + day;
end

if mod(year,4) == 0
    doy = doy + 1;
end

