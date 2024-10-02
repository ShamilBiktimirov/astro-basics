function angleWrapped = wrapAngleMinusPi2Pi(angle)

    if abs(angle) > pi  && angle > 0
        angleWrapped = - (2 * pi - angle);

    elseif abs(angle) > pi && angle < 0
        angleWrapped = 2 * pi + angle;
    else
        angleWrapped = angle;
    end

end
