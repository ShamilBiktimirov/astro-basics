function V_Earth_esc = V_Earth_esc(h)

    % Function for Low Earth circular orbit escape velocity calculation
    
    R_Earth = 6371; %[km]
    mu = 398600.5; %[km^3/s^2]
    r_NEO = R_Earth + h;
    
    V_Earth_esc = sqrt(2*mu/r_NEO);

end