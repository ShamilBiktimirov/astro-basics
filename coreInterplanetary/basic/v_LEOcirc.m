function v_LEOcirc = v_LEOcirc(h)

%Function for Low Earth circular orbit velocity calculation

R_Earth = 6371; %[km]
mu = 398600.5; %[km^3/s^2]
r_NEO = R_Earth + h;

v_LEOcirc = sqrt(mu/r_NEO);

end