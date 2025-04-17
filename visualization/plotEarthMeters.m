function globe = plotEarthMeters(GMST0, imgResoultion)

    %% Function plots 3D Earth

    %% Options
    % GMST0  is  in radian
    % imgResoultion either 1 or 10;
    npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
    alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible
    % GMST0 = []; % Don't set up rotatable globe (ECEF)
    % GMST0 = 4.89496121282306; % Set up a rotatable globe at J2000.0

    % Earth texture image
    % Anything imread() will handle, but needs to be a 2:1 unprojected globe
    % image.

    % image_file = 'http://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Land_ocean_ice_2048.jpg/1024px-Land_ocean_ice_2048.jpg';
    if imgResoultion == 1
        image_file = 'earthmap1k.jpg';
    elseif imgResoultion == 10
        image_file = 'earthmap10k.jpg';
    else
        error('Please input 1 or 10 for Earth surface image resoultion')
    end

    % Mean spherical earth

    erad = Consts.rEarth;     % equatorial radius (meters)
    prad = Consts.rEarth;     % polar radius (meters)
    erot = Consts.omegaEarth; % earth rotation rate (radians/sec)

    %% Create wireframe globe

    % Create a 3D meshgrid of the sphere points using the ellipsoid function

    [x, y, z] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);

    globe = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5 * [1 1 1]);

    if ~isempty(GMST0)

        hgx = hgtransform;
        set(hgx,'Matrix', makehgtform('zrotate',GMST0));
        set(globe,'Parent',hgx);

    end

    %% Texturemap the globe

    % Load Earth image for texture map

    cdata = imread(image_file);

    % Set image as color data (cdata) property, and set face color to indicate
    % a texturemap, which Matlab expects to be in cdata. Turn off the mesh edges.
    hold on;
    set(globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');
    xlabel('x-axis, m');
    ylabel('y-axis, m');
    zlabel('z-axis, m');
    axis equal;
    % axis off;

end
