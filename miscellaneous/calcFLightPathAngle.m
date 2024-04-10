function gamma = calcFLightPathAngle(r, v)

    % Function calculates flight path angle:
    % transvers to tangential direction

    % Input:
    % position vector r
    % velocity vector v

    % Output:
    % gamma, [rad] flight path angle

    eR = r ./ norm(r);
    eV = v ./ norm(v);

    eH = cross(eR, eV) ./ norm(cross(eR, eV));
    eT = cross(eH, eR);

    gamma = acos(dot(eV, eT));

end
