function vMarsEscKm = vMarsEsc(h)

    % Function for Low Mars circular orbit escape velocity calculation
    % Input:
    %   - h, orbit altitude, km
    % Output:
    %   - vMarsEsc, km/s

    rLMO = Consts.rMars + h;

    vMarsEsc = sqrt(2 * Consts.muMars / rLMO);
    vMarsEscKm = vMarsEsc / 1e3;

end
