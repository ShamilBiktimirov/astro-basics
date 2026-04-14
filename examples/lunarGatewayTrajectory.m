clear all;


cspice_furnsh(append(cd, '/naif/spiceKernels/naif0012.tls'));   % leap seconds
cspice_furnsh(append(cd, '/naif/spiceKernels/de440.bsp'));      % planetary ephemeris
cspice_furnsh(append(cd, '/naif/spiceKernels/pck00011.tpc'));   % planetary constants
cspice_furnsh(append(cd, '/naif/receding_horiz_3189_1burnApo_DiffCorr_15yr.bsp')); % Gateway NRHO

gatewayId = cspice_spkobj(append(cd, '/naif/receding_horiz_3189_1burnApo_DiffCorr_15yr.bsp'), 1000);

ephemCoverage_et = cspice_spkcov(append(cd, '/naif/receding_horiz_3189_1burnApo_DiffCorr_15yr.bsp'), gatewayId, 1000);
ephemCoverageRangeLander_utc = cspice_et2utc(ephemCoverage_et', 'C', 3);

% Example epoch

et = cspice_str2et('2026-04-13 TDB');

tSpan = [ephemCoverage_et(1): 3600: ephemCoverage_et(1) + 60*86400];
timeArray_utc_char = cspice_et2utc(tSpan, 'C', 3);
timeArray_utc_datetime = datetime(timeArray_utc_char, 'InputFormat', 'yyyy MMM dd HH:mm:ss.SSS');

[stateGateway, lt] = cspice_spkezr(cellstr(string(gatewayId)), tSpan, 'ECLIPJ2000', 'NONE', 'Earth');

[stateMoon, lt] = cspice_spkezr('MOON', tSpan, 'ECLIPJ2000', 'NONE', 'Earth');

[X,Y,Z] = sphere;
radiusMoon = 1737; % km
XMoon = X * radiusMoon;
YMoon = Y * radiusMoon;
ZMoon = Z * radiusMoon;


figure;
axis equal;
IdxStep = 1;

xlim([-400e3 400e3]);
ylim([-400e3 400e3]);
zlim([-200e3 200e3]);
view([1, 1, 0]);
ax.Clipping = 'off';
axis off;

for timeIdx = 1:IdxStep:length(tSpan)

    pltEarth = plotEarth('time', timeArray_utc_datetime(timeIdx), 'plotUnit', 'km', 'showAxes', 0, 'umbra', 0);
    pltGateway = plot3(stateGateway(1, timeIdx), stateGateway(2, timeIdx), stateGateway(3, timeIdx), 'or', 'MarkerSize', 2, 'MarkerFaceColor','auto');
    pltMoon = surf(XMoon + stateMoon(1, timeIdx), YMoon + stateMoon(2, timeIdx), ZMoon + stateMoon(3, timeIdx));

    drawnow;

    delete(pltMoon);
    delete(pltGateway);
    delete(pltEarth);

end
