function angleWrapped = wrapAngleMinusHalfPi2HalfPi(angle)

    if abs(angle) > pi / 2 && angle > 0
        angleWrapped = pi - angle ;

    elseif abs(angle) > pi / 2 && angle < 0
         angleWrapped = -angle - pi;
    else
        angleWrapped = angle;
    end

end
