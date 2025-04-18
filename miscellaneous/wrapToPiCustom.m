function angleOut = wrapToPiCustom(angleIn)

    % The function converts an angle in radian ranging from 0 to 2pi to range from -pi to pi
    % Works for array of input values. If value is more than 2pi it considers the remainder after division to 2pi


    angleOut = [];

    if all(angleIn <= pi & angleIn >= -pi)
        % check if angles suite the range
        angleOut = angleIn;

    else

        angleOut = rem(angleIn, 2 * pi); % make angles in a range from -2*pi to 2*pi
        idxNegativeAngle = find(angleOut < 0);
        angleOut(idxNegativeAngle) = 2 * pi + angleOut(idxNegativeAngle); % make angles in a range from 0 to 2*pi

        idxBiggerThanPi = find(angleOut > pi);
        angleOut(idxBiggerThanPi) = - 2 * pi + angleOut(idxBiggerThanPi);

    end

    assert(all(angleOut <= pi & angleOut >= -pi), "angles does not satisfy range from -pi to pi");

end
