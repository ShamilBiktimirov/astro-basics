function trans = matran (a1, nax1, a2, nax2, a3, nax3, a4, nax4)

% this function computes a transformation matrix for a
% given rotation sequence of up to four rotations about the
% x, y, or z axes.  the first row of the matrix contains the
% direction cosines of the new x-axis with respect to the
% original xyz axes.  the second row is the y-axis and the
% third row is the z-axis.

% in equation form

%  x2           (1,1  1,2  1,3)   (x1)
%  y2  =  trans (2,1  2,2  2,3) * (y1)
%  z2           (3,1  3,2  3,3)   (z1)

% input

%  a1, a2, a3, a4 = rotation angle about the respective axis (radians)

%  nax1, nax2, nax3, nax4 = axis of rotation
%                           (1 = x, 2 = y, 3 = z, 0 = no more rotations)

% output

%  trans = transformation matrix (3 rows by 3 columns)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% call rotmat1 to compute the transformation matrix for a given
% rotation (a1...a4) about a given axis (nax1...nax4)

trans = rotmat1 (a1, nax1);

if (nax2 == 0)
    return
end

trans1 = rotmat1 (a2, nax2);

tran = trans1 * trans;

if (nax3 == 0)
    trans = tran;

    return
end

trans1 = rotmat1 (a3, nax3);

trans = trans1 * tran;

if (nax4 == 0)
    return
end

trans1 = rotmat1 (a4, nax4);

tran = trans1 * trans;

trans = tran;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function trans = rotmat1 (angle, naxis)

% this function computes a transformation matrix for a
% given rotation about the x, y, or z-axis.  the first row
% of the matrix contains the direction cosines of the new
% x-axis with respect to the original xyz axes.  the second
% row is the y-axis and the third row is the z-axis.

% in equation form

%  x2         (1,1  1,2  1,3)   (x1)
%  y2 = trans (2,1  2,2  2,3) * (y1)
%  z2         (3,1  3,2  3,3)   (z1)

% input

%  angle = rotation angle (radians)
%          (measured positive for counter-clockwise
%          rotations as seen from the pole of the axis
%          of rotation - right hand rotion)

%  naxis = axis of rotation (1 = x, 2 = y, 3 = z)

% output

%  trans = transformation matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize trans array (transformation matrix)

trans = zeros(3);

% calculate the cosines and sines of the input angle

cosang = cos(angle);

sinang = sin(angle);

if (naxis == 1)

    % compute transformation matrix for rotation about the x-axis

    trans(1, 1) = 1.0d0;
    trans(2, 2) = cosang;
    trans(2, 3) = sinang;
    trans(3, 2) = -sinang;
    trans(3, 3) = cosang;

elseif (naxis == 2)

    % compute transformation matrix for rotation about the y-axis

    trans(1, 1) = cosang;
    trans(1, 3) = -sinang;
    trans(2, 2) = 1.0d0;
    trans(3, 1) = sinang;
    trans(3, 3) = cosang;

else

    % compute transformation matrix for rotation about the z-axis

    trans(1, 1) = cosang;
    trans(1, 2) = sinang;
    trans(2, 1) = -sinang;
    trans(2, 2) = cosang;
    trans(3, 3) = 1.0d0;

end



