function [mBrwa, rwaAngAcc] = torqueAllocationToRWA(mBIdeal, Jrw, Arwa, ArwaInv, rwAngAccMax)

    rwaAngAcc = -ArwaInv * mBIdeal / Jrw; % rad/s^2

    rwaAngAcc = controlVectorSaturationProcessing(rwaAngAcc, 'component', rwAngAccMax);

    mBrwa = -Arwa * Jrw * rwaAngAcc; %

end
