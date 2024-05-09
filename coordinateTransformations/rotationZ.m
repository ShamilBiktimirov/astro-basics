function matrix = rotationZ(angleRad)

    matrix = [cos(angleRad), -sin(angleRad), 0; ...
              sin(angleRad), cos(angleRad), 0; ...
              0, 0, 1];

end