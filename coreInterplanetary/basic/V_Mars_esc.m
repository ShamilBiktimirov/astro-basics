function V_Mars_esc = V_Mars_esc(h)

%Function for Low Mars circular orbit escape velocity calculation


R_Mars = 3398.5; %[km]
mu = 42828; %[km^3/s^2]
r_LMO = R_Mars + h;

V_Mars_esc = sqrt(2*mu/r_LMO);

end