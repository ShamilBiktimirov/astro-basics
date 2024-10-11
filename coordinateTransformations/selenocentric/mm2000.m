function tmatrix = mm2000 (jdate)

% eme2000 to moon mean equator and IAU node
% of epoch transformation matrix

% input

%  jdate = TDB julian date

% output

%  tmatrix = transformation matrix

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dtr = pi / 180.0d0;

% time arguments

t = (jdate - 2451545.0d0) / 36525.0d0;

d = jdate - 2451545.0d0;

% iau 2000 pole orientation

e1 = 125.045d0 -  0.0529921d0 * d;

e2 = 250.089d0 -  0.1059842d0 * d;

e3 = 260.008d0 + 13.0120009d0 * d;

e4 = 176.625d0 + 13.3407154d0 * d;

e6 = 311.589d0 + 26.4057084d0 * d;

e7 = 134.963d0 + 13.0649930d0 * d;

e10 = 15.134d0 -  0.1589763d0 * d;

e13 = 25.053d0 + 12.9590088d0 * d;

rasc_pole = 269.9949d0 + 0.0031d0 * t ...
    - 3.8787d0 * sin(dtr * e1) ...
    - 0.1204d0 * sin(dtr * e2) ...
    + 0.0700d0 * sin(dtr * e3) ...
    - 0.0172d0 * sin(dtr * e4) ...
    + 0.0072d0 * sin(dtr * e6) ...
    - 0.0052d0 * sin(dtr * e10) ...
    + 0.0043d0 * sin(dtr * e13);

decl_pole = 66.5392d0 + 0.0130d0 * t ...
    + 1.5419d0 * cos(dtr * e1) ...
    + 0.0239d0 * cos(dtr * e2) ...
    - 0.0278d0 * cos(dtr * e3) ...
    + 0.0068d0 * cos(dtr * e4) ...
    - 0.0029d0 * cos(dtr * e6) ...
    + 0.0009d0 * cos(dtr * e7) ...
    + 0.0008d0 * cos(dtr * e10) ...
    - 0.0009d0 * cos(dtr * e13);

% compute the unit vector in the direction of the moon's pole

phat_moon(1) = cos(rasc_pole * dtr) * cos(decl_pole * dtr);

phat_moon(2) = sin(rasc_pole * dtr) * cos(decl_pole * dtr);

phat_moon(3) = sin(decl_pole * dtr);

zhat(1) = 0.0d0;
zhat(2) = 0.0d0;
zhat(3) = 1.0d0;

% x-direction

xvec = cross (zhat, phat_moon);

xhat = xvec / norm(xvec);

% y-direction

yvec = cross (phat_moon, xhat);

yhat = yvec / norm(yvec);

% load elements of transformation matrix

tmatrix(1, 1) = xhat(1);
tmatrix(1, 2) = xhat(2);
tmatrix(1, 3) = xhat(3);

tmatrix(2, 1) = yhat(1);
tmatrix(2, 2) = yhat(2);
tmatrix(2, 3) = yhat(3);

tmatrix(3, 1) = phat_moon(1);
tmatrix(3, 2) = phat_moon(2);
tmatrix(3, 3) = phat_moon(3);


