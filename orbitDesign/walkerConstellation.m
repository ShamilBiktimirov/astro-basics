function oes = walkerConstellation(T, P, f, a, inc, walkerType)

    oes = zeros(T, 6);
    q = T/P;
    e = 0;
    w = 0;

    if strcmpi(walkerType, 'star')
        delta_RAAN = 180/P;
    elseif strcmpi(walkerType ,'delta')
        delta_RAAN = 360/P;
    else
        error('incorrect walker type');
    end

    i = 0;
    for k = 1:P
        for j = 1:q
            i = i + 1;
            RAAN = deg2rad(mod((k - 1)*delta_RAAN, 360));
            M = deg2rad(mod(360*(j - 1)/q + 360*f*(k - 1)/T, 360));
            oes(i,:) = [a; e; inc; RAAN; w; M];
        end
    end

end
