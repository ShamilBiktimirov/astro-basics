function angleOut = wrapToPiCustom(angleIn)

    angleOut = [];
    
    for idx = 1:length(angleIn)

            if abs(angleIn(idx)) > pi
                if angleIn(idx) < 0
                    angleOut(idx) = 2 * pi + angleIn(idx);
                elseif angleIn > 0
                    angleOut(idx) = -2 * pi + angleIn(idx);
                end
            else
                angleOut(idx) = angleIn(idx);
            end

    end

end
