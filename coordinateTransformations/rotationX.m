function matrix = rotationX(angleRad)

    matrix = [1, 0, 0; ...
              0, cos(angleRad), -sin(angleRad); ...
              0, sin(angleRad), cos(angleRad)];

end