function [kDay2Rep, kRev2Rep] = findOrbitRgtProperties(a, i)

    % Function estimates a circular orbit repeat ground track properties

    % Input:
    % a, [m], mean orbit sma
    % i, [rad], mean orbit inclination

    % Output:
    % kDay2Rep, [], number of nodal days for an rgt orbit to repeat (repeat cycle)
    % kRev2Rep, [], number of satellite revolutions for an rgt to repeat

    % Note: if the orbit has no resonance properties it returns empty values
    %       orbits with kDay2Rep <= 100 and kRev2Rep < 1000 are considered


    %% Calculates Earth and satellite nodal periods and its ratio

    T_sat_nodal_local = calcDraconicPeriod([a, 0, i]);

    [raanDot, ~, ~] = calcSecularPrecessionRates(a, 0, i);
    % make a function for Earth nodal period
    T0 = 2 * pi / (Consts.omegaEarth - raanDot);

    NpToSt = T_sat_nodal_local / T0;

    %% Builds a matrix of possible RGT orbits ration

    kDay2RepArray = [1:1000]';
    kRev2RepArray = 1 ./ [10:10000];

    opportunitiesMatrix = kDay2RepArray * kRev2RepArray;

    % critical nodal periods ratio - when satellite is above the Earth surface

    criticalRatio = 1 / 10; % can be for one that is above Karman line altitude

    [opportunitiesMatrixIdxRow, opportunitiesMatrixIdxCol] = find(opportunitiesMatrix > criticalRatio);

    for caseIdx = 1:length(opportunitiesMatrixIdxCol)

        opportunitiesMatrix(opportunitiesMatrixIdxRow(caseIdx), opportunitiesMatrixIdxCol(caseIdx)) = 0;

    end

    [row, col] = find((abs(opportunitiesMatrix - NpToSt) < 1e-6));

    % think about precision
    % at some precision multiple orbits might be as a solution
    % the precision might be such that yields the same solutions 1/15 - 2/30
    % if solutions are different, make poker face - rat

    if ~isempty(row)

        check = kDay2RepArray((row)) .* kRev2RepArray(col)';
        checkBulbul = all(abs(check - check(1)) < 1e-16);
        if checkBulbul
            rgtData = [kDay2RepArray(min(row)), 1 / kRev2RepArray(min(col))];

            kDay2Rep = rgtData(1);
            kRev2Rep = rgtData(2);
        else
            warning('ahaha, your code is weiiiiird, ghariba');
            kDay2Rep = [];
            kRev2Rep = [];

        end

    else
        warning('Orbit is not repeat ground track');

        kDay2Rep = [];
        kRev2Rep = [];
    
    end


end
