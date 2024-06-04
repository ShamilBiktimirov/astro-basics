function matrix = rotationY(angleRad)

    matrix = [cos(angleRad), 0, -sin(angleRad); ...
              0, 1, 0; ...
              sin(angleRad), 0, cos(angleRad)];

end