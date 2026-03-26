function M = dcmFeedbackControlLaw(dcmReqI, X, J)

    kOmega = 0.2;
    kS     = 0.01;

    qIB = X(1:4);
    omegaB = X(5:7);
    omegaRef = [0; 0; 0]; 
    % so far is considered as zero but can be an angular velocity depending
    % on direction to the asteroid
    D_BI = quat2dcm(qIB'); % quat2dcm uses passive rotation
    A = D_BI * dcmReqI;
    omegaRel = omegaB - D_BI * omegaRef;

    s = [A(2, 3) - A(3, 2); A(3, 1) - A(1, 3); A(1, 2) - A(2, 1)];

    M = cross(omegaB, J * omegaB) - J * cross(omegaRel, A * omegaRef) ...
        - kOmega * omegaRel - kS * s;

end
