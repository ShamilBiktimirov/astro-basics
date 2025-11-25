function [mBrwa, rwaAngAcc] = torqueAllocationToRWA(mBIdeal, Jrw, Arwa, ArwaInv, rwAngAccMax)

    rwaAngAcc = -ArwaInv * mBIdeal / Jrw; % rad/s^2

    if any(abs(rwaAngAcc) > rwAngAccMax)
        % torque saturation
        rwaAngAcc = rwaAngAcc / max(abs(rwaAngAcc)) * rwAngAccMax;
    end

    mBrwa = -Arwa * Jrw * rwaAngAcc; %

    % here we don't consider angular momentum saturation

end
