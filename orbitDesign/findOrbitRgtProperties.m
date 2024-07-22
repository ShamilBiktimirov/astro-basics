function [kDay2Rep, kRev2Rep] = findOrbitRgtProperties(a, i)

    % Function estimates a circular orbit repeat ground track properties

    % Input:
    % a, [m], mean orbit sma
    % i, [rad], mean orbit inclination

    % Output:
    % kDay2Rep, [], number of nodal days for an rgt orbit to repeat (repeat cycle)
    % kRev2Rep, [], number of satellite revolutions for an rgt to repeat

    % Note: if the orbit has no resonance properties it returns empty values
    %       orbits with kDay2Rep <= 1000 and kRev2Rep < 10000 are considered


    %% Calculates Earth and satellite nodal periods and its ratio

    pSatNodal = calcDraconicPeriod([a; 0; i]);

    pEarthNodal = calcEarthNodalPeriod(a, 0, i);

    PSatToEarth = pSatNodal / pEarthNodal;

    %% Builds a matrix of possible RGT orbits ration

    kDay2RepArray = [1 : 1000]';
    kRev2RepArray = 1 ./ [10 : 10000];

    opportunitiesMatrix = kDay2RepArray * kRev2RepArray;

    % critical nodal periods ratio - when satellite is above the Earth surface

    criticalRatio = 1 / 10; % can be for one that is above Karman line altitude

    [opportunitiesMatrixIdxRow, opportunitiesMatrixIdxCol] = find(opportunitiesMatrix > criticalRatio);

    for caseIdx = 1 : length(opportunitiesMatrixIdxCol)

        opportunitiesMatrix(opportunitiesMatrixIdxRow(caseIdx), opportunitiesMatrixIdxCol(caseIdx)) = 0;

    end
    
    % based on the tolerance it gives different output.
    % for low tolerance, it might give different rgt orbit some of them
    % might be same orbit i.e 1/15 and 2/30, but some might be different. 
    % if the orbits are all same then it is fine, but if it gives different
    % orbits this means that the tolerance is low and the results are not accurate. This will show warning message.

    [row, col] = find((abs(opportunitiesMatrix - PSatToEarth) < 1e-10));


    if ~isempty(row)

        check = kDay2RepArray((row)) .* kRev2RepArray(col)';
        checkSimilarRgtOrbits = all(abs(check - check(1)) < 1e-16);

        if checkSimilarRgtOrbits

            rgtData = [kDay2RepArray(min(row)), 1 / kRev2RepArray(min(col))];

            kDay2Rep = rgtData(1);
            kRev2Rep = rgtData(2);
        else
            warning('Multiple different rgt orbits are found because the tolerance is very low, please increase the tolerance to get an accurate output');
            kDay2Rep = [];
            kRev2Rep = [];

        end

    else
        warning('Orbit is not repeat ground track');

        kDay2Rep = [];
        kRev2Rep = [];
    
    end


end
