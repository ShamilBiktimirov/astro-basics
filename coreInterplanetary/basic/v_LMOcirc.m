function v_LMOcirc = v_LMOcirc(h)

%Function for Low Mars circular orbit velocity calculation

R_Mars = 3398.5; %[km]
mu = 42828; %[km^3/s^2]
r_LMO = R_Mars + h;

v_LMOcirc = sqrt(mu/r_LMO);

end