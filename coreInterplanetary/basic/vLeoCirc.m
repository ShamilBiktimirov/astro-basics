function vLeoCircKm = vLeoCirc(h)

    % Function for Low Earth circular orbit velocity calculation
    % Input:
    %   - h, orbit altitude, km
    % Ouput:
    %   - vLeoCircKm, speed at circular orbit, km

    rLeo = Consts.rEarth + h;

    vLeoCirc = sqrt(Consts.muEarth / rLeo);
    vLeoCircKm = vLeoCirc / 1e3;

end
