function rECEF = ECI2ECEF(Jd ,rEci)

    % Inputs:

    % Jd                     [N x 1]                       Julian Date Vector
    %
    % rEci                   [3 x N]                       Position Vector
    %                                                      in ECI coordinate
    %                                                      frame of reference

    % Outputs:

    % rEcef                 [3 x N]                       Position Vector in ECEF frame

    % References:
    % Orbital Mechanics with Numerit, http://www.cdeagle.com/omnum/pdf/csystems.pdf
    %
    %
    % Function Dependencies:
    %------------------
    % JD2GMST
    %------------------------------------------------------------------       %
    % Programed by Darin Koblick  07-05-2010                                  %
    % Modified on 03/01/2012 to add acceleration vector support               %
    % Revised by Shamil Biktimirov on Oct, 12, 2023

    % Calculate the Greenwich Apparent Sideral Time (THETA)
    % See http://www.cdeagle.com/omnum/pdf/csystems.pdf equation 27
    theta = JD2GAST(Jd);

    % Assemble the transformation matricies to go from ECI to ECEF
    % See http://www.cdeagle.com/omnum/pdf/csystems.pdf equation 26

    rECEF = squeeze(MultiDimMatrixMultiply(T3D(theta), rEci));

    function C = MultiDimMatrixMultiply(A, B)
        C = sum(bsxfun(@times, A, repmat(permute(B', [3 2 1]), [size(A, 2) 1 1])), 2);
    end

    function T = T3D(THETA)
        T = zeros([3 3 length(THETA)]);
        T(1, 1, :) = cosd(THETA);
        T(1, 2, :) = sind(THETA);
        T(2, 1, :) = -T(1, 2, :);
        T(2, 2, :) = T(1, 1, :);
        T(3, 3, :) = ones(size(THETA));
    end

end
