function r = calcOrbitRadius(oe)

    % Input:
    % oe = [a; e; i; RAAN; AOP; TA]

    % Output:
    % r - radial distance

    a = oe(1);
    e = oe(2);
    f = oe(6);

    p = a * (1 - e^2);

    r = p / (1 + e * cos(f));

end
