function [verticesPositionsArray, linksArray] = calcParallelepidedVecticesPositions(sideLengths)

    % The function is used to iniate parallelepiped for further illustrations/animations

    l1 = sideLengths(1);
    l2 = sideLengths(2);
    l3 = sideLengths(3);

    p1 = [l1 / 2; l2 / 2; -l3 / 2];
    p2 = [-l1 / 2; l2 / 2; -l3 / 2];
    p3 = [-l1 / 2; -l2 / 2; -l3 / 2];
    p4 = [l1 / 2; -l2 / 2; -l3 / 2];
    p5 = [l1 / 2; l2 / 2; l3 / 2];
    p6 = [-l1 / 2; l2 / 2; l3 / 2];
    p7 = [-l1 / 2; -l2 / 2; l3 / 2];
    p8 = [l1 / 2; -l2 / 2; l3 / 2];

    verticesPositionsArray = [p1, p2, p3, p4, p5, p6, p7, p8];

    linksArray = [1 5 8 5 1; ...
                  1 2 6 5 1; ...
                  5 6 7 8 5; ...
                  2 6 7 3 2; ...
                  4 3 7 8 4; ...
                  1 2 3 4 1]';

end
