function oeOut = meanOscMapping(oeIn, direction)

    %% function performs first-orded mapping between
    % osculation or instantaneous) and 
    % mean or orbit averaged, with short- and long-period motion removed)

    % only J2 term is retained 

    % input: classical orbital elements [a, e, i, RAAN, AOP, MA]

    % output: [a, e, i, RAAN, AOP, MA] transformed

    % reference:
    % Schaub, Hanspeter, and John L. Junkins. Analytical mechanics of space
    % systems. Aiaa, 2003, Appendix F

    % The algorithm is based on Brouwer Lyddane theory

    % Not vectorized


    %%
    a    = oeIn(1);
    e    = oeIn(2);
    i    = oeIn(3);
    RAAN = oeIn(4);
    AOP  = oeIn(5);
    MA   = oeIn(6);

    if strcmpi(direction, 'osc2mean')

        gamma2 = -Consts.earthJ2 / 2 * (Consts.rEarthEquatorial / a)^2;

    elseif strcmpi(direction, 'mean2osc')

        gamma2 = Consts.earthJ2 / 2 * (Consts.rEarthEquatorial / a)^2;

    else

        error("Improper osc to mean conversion specified");

    end

    eta = sqrt(1 - e^2);

    gamma2Prime = gamma2 / eta^4;

    [~, f] = newtonm(e, MA);

    aOverR = (1 + e * cos(f)) / eta^2;

    % finding transformed sma
    aPrime = a + a * gamma2 * ...
                            ((3 * cos(i)^2 - 1) * (aOverR^3 - 1 / eta^3) + 3 * (1 - cos(i)^2) * aOverR^3 * cos(2 * AOP + 2 * f));

    de1 = gamma2Prime / 8 * e * eta^2 * ...
                                      (1 - 11 * cos(i)^2 - 40 * cos(i)^4 / (1 - 5 * cos(i)^2)) * cos(2 * AOP);

    de  = de1 + ...
          eta^2 / 2 * ...
                   (gamma2 * ( ...
                             (3 * cos(i)^2 - 1) / eta^6 * (e * eta + e / (1 + eta) + 3 * cos(f) + 3 * e * cos(f)^2 + e^2 * cos(f)^3) + ...
                              3 * (1 - cos(i)^2) / eta^6 * (e + 3 * cos(f) + 3 * e * cos(f)^2 + e^2 * cos(f)^3) * cos(2 * f + 2 * AOP)) ...
                     - gamma2Prime * (1 - cos(i)^2) * (3 * cos(2 * AOP + f) + cos(2 * AOP + 3 * f)));

    di = - e * de1 / (eta^2 * tan(i)) + ...
         gamma2Prime / 2 * cos(i) * sqrt(1 - cos(i)^2) * (3 * cos(2 * AOP + 2 * f) + 3 * e * cos(2 * AOP + f) + e * cos(2 * AOP + 3 * f));

    MA_AOP_RAAN_prime = MA + AOP + RAAN + ...
                       gamma2Prime / 8 * eta^3 * (1 - 11 * cos(i)^2 - 40 * cos(i)^4 / (1 - 5 * cos(i)^2)) ...
                       - gamma2Prime / 16 * (2 + e^2 - 11 * (2 + 3 * e^2) * cos(i)^2 - 40 * (2 + 5 * e^2) * cos(i)^4 / (1 - 5 * cos(i)^2) - 400 * e^2 * cos(i)^6 / (1 - 5 * cos(i)^2)^2) ...
                       + gamma2Prime / 4 * (-6 * (1 - 5 * cos(i)^2) * (f - MA + e * sin(f)) + (3 - 5 * cos(i)^2) * (3 * sin(2 * AOP + 2 * f) + 3 * e * sin(2 * AOP + f) + e * (sin(2 * AOP + 3 * f)))) ...
                       - gamma2Prime / 8 * e^2 * cos(i) * (11 + 80 * cos(i)^2 / (1 - 5 * cos(i)^2) + 200 * cos(i)^4 / (1 - 5 * cos(i)^2)^2) ...
                       - gamma2Prime / 2 * cos(i) * (6 * (f - MA + e * sin(f)) - 3 * sin(2 * AOP + 2 * f) - 3 * e * sin(2 * AOP + f) - e * sin(2 * AOP + 3 * f));

    edMA = gamma2Prime / 8 * e * eta^3 * (1 - 11 * cos(i)^2 - 40 * cos(i)^4 / (1 - 5 * cos(i)^2)) ...
           - gamma2Prime/4 * eta^3 * (2 * (3 * cos(i)^2 - 1) * ((aOverR * eta)^2 + aOverR + 1) * sin(f) ...
                                      + 3 * (1 - cos(i)^2) * ((- (aOverR * eta)^2 - aOverR + 1) * sin(2 * AOP + f) ...
                                                              + ((aOverR * eta)^2 + aOverR + 1/3) * sin(2 * AOP + 3 * f)));

    dRAAN = -gamma2Prime / 8 * e^2 * cos(i) * (11 + 80 * cos(i)^2 / (1 - 5 * cos(i)^2) + 200 * cos(i)^4 / (1 - 5 * cos(i)^2)^2) ...
            - gamma2Prime / 2 * cos(i) * (6 * (f - MA + e * sin(f)) - 3 * sin(2 * AOP + 2 * f) - 3 * e * sin(2 * AOP + f) - e * sin(2 * AOP + 3 * f));

    d1 = (e + de) * sin(MA) + edMA * cos(MA);
    d2 = (e + de) * cos(MA) - edMA * sin(MA);

    MAPrime = atan2(d1, d2); % should be from 0 to 2pi

    ePrime = sqrt(d1^2 + d2^2); % should be positive and smaller than 1

    d3 = (sin(i/2) + cos(i/2) * di / 2) * sin(RAAN) + sin(i/2) * dRAAN * cos(RAAN);
    d4 = (sin(i/2) + cos(i/2) * di / 2) * cos(RAAN) - sin(i/2) * dRAAN * sin(RAAN);

    RAANPrime = atan2(d3, d4);
    iPrime = 2 * asin(sqrt(d3^2 + d4^2));

    AOPPrime = MA_AOP_RAAN_prime - MAPrime - RAANPrime;

    oeOut = [aPrime; ePrime; iPrime; RAANPrime; AOPPrime; MAPrime];

end
