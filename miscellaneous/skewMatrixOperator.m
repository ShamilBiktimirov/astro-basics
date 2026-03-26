function A = skewMatrixOperator(r)

    % Skew symmetric matrix of vector cross product operator

    A = [0 -r(3) r(2); ...
         r(3) 0 -r(1); ...
         -r(2) r(1) 0];

end
