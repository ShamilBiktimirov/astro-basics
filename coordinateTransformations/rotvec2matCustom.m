function rotMat = rotvec2matCustom(k)

    % Uses the Rodrigues formula en.wikipedia.org/wiki/Rodrigues%27_rotation_formula#Matrix_notation

    assert(length(k) == 3,"rotvec2mat(k): k is not a 3D vector"); % make sure its a 3D vector

    t = norm(k); % get norm representing angle of rotation

    if t < realmin("single")

        rotMat = eye(3);

    else

        r = k / t; % normalise vector
        K = [0, -r(3), r(2);
             r(3), 0, -r(1);
             -r(2), r(1), 0];

        K2 = K * K;
        rotMat = eye(3) + sin(t) * K + (1-cos(t)) * K2;

    end

end
