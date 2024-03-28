function u = meanDoeFeedbackRegulator(oe_mean_current, oe_mean_required, pGainsData)

    % Function calculates contro input for mean oe feedback control law
    % based on the Lyapunov functions theorem

    % Input:
    % oe_mean_current,  [a, e, i, RAAN, AOP, MA]
    % oe_mean_required, [a, e, i, RAAN, AOP, MA]

    % Output:
    % u 3x1, control input, N/kg

    oe_osc_current = meanOscMapping(oe_mean_current, "mean2osc");
    rvECI_current  = oe2rv(oe_osc_current);

    doe = zeros(6, 1);

    doe = oe_mean_current - oe_mean_required;
    doe(1) = doe(1) / Consts.rEarth;

    % calculates control gain matrix which is time dependent
    P = zeros(6);
    f = oe_osc_current(6);
    theta = oe_osc_current(5) + oe_osc_current(6);

    % should be tuned, and maybe even passed from outside
    P(1, 1) = pGainsData(1, 1) + pGainsData(1, 2) * cos(f/2)  ^ pGainsData(1, 3);
    P(2, 2) = pGainsData(2, 1) + pGainsData(2, 2) * cos(f)    ^ pGainsData(2, 3);
    P(3, 3) = pGainsData(3, 1) + pGainsData(3, 2) * cos(theta)^ pGainsData(3, 3);
    P(4, 4) = pGainsData(4, 1) + pGainsData(4, 2) * sin(theta)^ pGainsData(4, 3);
    P(5, 5) = pGainsData(5, 1) + pGainsData(5, 2) * sin(f)    ^ pGainsData(5, 3);
    P(6, 6) = pGainsData(6, 1) + pGainsData(6, 2) * sin(f)    ^ pGainsData(6, 3);

    rhs = - (calcAvector(oe_mean_current) - calcAvector(oe_mean_required)) - P * doe;

    B = calcBmatrix(oe_mean_current);

    B_inv = pinv(B);
    uOrb = B_inv * rhs;

    if any(isnan(uOrb))
        uOrb = [0; 0; 0];
    end

    A = orb2EciMatrix(rvECI_current);

    u = A * uOrb;

    if norm(u) > 1e-4
        u = u ./ norm(u) * 1e-4;
    end

end
