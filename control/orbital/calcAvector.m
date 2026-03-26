function A = calcAvector(oeMean)

  n = sqrt(Consts.muEarth / oeMean(1)^3);
  eta = sqrt(1 - oeMean(2)^2);
  p = oeMean(1) * eta^2;
  i = oeMean(3);

  A = zeros(6, 1);

  A(4, 1) = - 3/2 * Consts.earthJ2 * (Consts.rEarthEquatorial / p)^2 * n * cos(i);

  A(5, 1) = 3/4 * Consts.earthJ2 * (Consts.rEarthEquatorial / p)^2 * n * (5 * cos(i)^2 - 1);

  A(6, 1) = n + 3/4 * Consts.earthJ2 * (Consts.rEarthEquatorial / p)^2 * eta * n * (3 * cos(i)^2 - 1);

end
