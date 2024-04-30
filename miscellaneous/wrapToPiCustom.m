function angleOut = wrapToPiCustom(angleIn)

    if abs(angleIn) > pi
        if angleIn < 0
            angleOut = 2 * pi + angleIn;
        elseif angleIn > 0
            angleOut = -2 * pi + angleIn;
        end
    else
        angleOut = angleIn;
    end

end
