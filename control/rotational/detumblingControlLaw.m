function M_B = detumblingControlLaw(omegaRefI, X, J)

    kOmega = 0.1;

    qIB = X(1:4);
    omegaB = X(5:7);

    D_BI = quat2dcm(qIB'); % quat2dcm uses passive rotation

    omegaRelB = omegaB - D_BI * omegaRefI;

    M_B = cross(omegaB, J * omegaB) - J * cross(omegaRelB, D_BI * omegaRefI) - kOmega * omegaRelB;
    % note that term dot omega ref is equal to zero

end
