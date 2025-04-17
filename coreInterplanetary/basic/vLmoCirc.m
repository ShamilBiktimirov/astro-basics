function vLmoCircKm = vLmoCirc(h)

    % Function for Low Mars circular orbit velocity calculation
    % Input:
    %    - h, orbit altitude, km
    % Output:
    %    - vLmoCircKm, velocity at circular orbit around Mars, km/s

    rLmo = Consts.rMars + h;

    vLmoCirc = sqrt(Consts.muMars / rLmo);
    vLmoCircKm = vLmoCirc / 1e3;

end
