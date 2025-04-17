function vEarthEscKm = vEarthEsc(h)

    % Function for Low Earth circular orbit escape velocity calculation
    % Input: 
    %   - orbit altitude, km
    % Output:
    %   - vEarthEsc, km/s

    r_NEO = Consts.rEarth + h * 1e3;

    vEarthEsc = sqrt(2 * Consts.muEarth / r_NEO);

    vEarthEscKm = vEarthEscKm / 1e3;

end
