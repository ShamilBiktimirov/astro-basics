function earth3D = plotEarth(varargin)

    % The function plots 3D Earth with different options using varargin.
    % It plots spherical Earth with project 2d onto it.

    % Optional varargin inputs:

    % "plotUnit": Earth plot unit
    % "plotUnit" can be 'm' or 'km', default is 'm'

    % "imageResolution": resoultion of the Earth surface image projected onto a sphere
    % "imageResolution": can be '1k' or '10k', default is '1k'

    % "time": can be specified as UTC datetime or Julian day form
    % "GAST": Greenwich Apparent Sidereal Time, deg
    % GAST is the angle from Greenwich meridian to true vernal Equinox
    % True vernal Equinox is the intersection between the true equator and Ecliptic plane

    % "umbra": Earth shadow
    % "umbra": can be 0 or 1, by default is 1 which means shadow is on.

    % "showAxes": to show ECI and ECEF axes 
    % "showAxes": can be 0 or 1, by default is 1 which means axes is on. 

    % "figView": to specify view direction for the figure
    % "figView": [x, y, z], default [1, 1, 0.5]

    % Comments:
    % A user can specifiy the time in datetime UTC, in julian days or alternatively sat GAST for the plot
    % if time is not provided, the default will be 'now' in UTC
    % if GAST provided without time then umbra will be off

    % umbra will be added to the plot by default based on time
    % user can switch off umbra, see below the optional inputs

    % ECI and ECEF axes are added to the plot by default and it follows
    % either time or GAST or uses current time if non of it is not specified
    % axes can be switched off
    % default view direction is defined by vector [1, 1, 0.5] and can be
    % adjusted


    %% checking optional inputs
    parser = inputParser;

    defaultUnit = 'm';
    defaultImageRes = '1k';
    defaultTime = juliandate(datetime('now'));
    defaultGAST = JD2GAST(defaultTime);
    defaultUmbra = 1;
    defaultShowAxes = 1;
    defaultView = [1, 1, 0.5];


    addOptional(parser,'plotUnit', defaultUnit);
    addOptional(parser,'imageResolution', defaultImageRes);
    addOptional(parser,'time', defaultTime);
    addOptional(parser,'GAST', defaultGAST);
    addOptional(parser,'umbra', defaultUmbra);
    addOptional(parser,'showAxes', defaultShowAxes);
    addOptional(parser,'figview', defaultView);


    % Parse the inputs
    parse(parser, varargin{:});

    args = parser.Results;
    usedDefaults = parser.UsingDefaults;

    % Determine what the user specified
    userSpecified.time = ~ismember('time', usedDefaults);
    userSpecified.GAST = ~ismember('GAST', usedDefaults);

    % Extract parsed values
    plotUnit = args.plotUnit;
    imageResolution = args.imageResolution;
    umbra = args.umbra;
    showAxes = args.showAxes;
    figview = args.figview;


    % check timeJD and timeGD
    if userSpecified.time == 0 && userSpecified.GAST == 0
        time = args.time;
        GAST = args.GAST;

    elseif userSpecified.time == 1 && userSpecified.GAST == 0

        time = args.time;

       % Check if timeJD is provided as datetime or Julian Date
        if isa(time, 'datetime')
            % If timeJD is a datetime, convert it to Julian Date
            time = juliandate(time);
        elseif ~isnumeric(time)
            error('The time must be either a datetime or a numeric Julian date.');
        end

        GAST = JD2GAST(time);

    elseif userSpecified.time == 0 && userSpecified.GAST == 1
        GAST = args.GAST;
        umbra = 0;
        warning('Umbra is switched off since GAST is provided without time');

    elseif userSpecified.time == 1 && userSpecified.GAST == 1

        % If both timeJD and timeGD are provided, check if they match
        time = args.time;

         % Check if timeJD is provided as datetime or Julian Date
        if isa(time, 'datetime')
            % If timeJD is a datetime, convert it to Julian Date
            time = juliandate(time);
        elseif ~isnumeric(time)
            error('The time must be either a datetime or a numeric Julian date.');
        end

        GAST = args.GAST;

        % Convert timeGD back to Julian Date to check if they match
        calculatedGD = JD2GAST(time); % deg

        if abs(calculatedGD - GAST) > 1e-5  % Small tolerance
            error('The time and GAST values do not match. Please provide consistent values.');
        end
    end


    % Check if plotUnit is valid
    if ~strcmp(plotUnit, 'm') && ~strcmp(plotUnit, 'km')
        error('The plotUnit is not correct, please input either m or km');
    end

    % Check if imageResolution is valid
    if ~strcmp(imageResolution, '1k') && ~strcmp(imageResolution, '10k')
        error('The imageResolution is not correct, please input either 1k or 10k');
    end

    % give warning that the plot will be based on the default time
    % which is 'now' since time is not provided by the user. Also,
    % umbra will be based on that.

    if userSpecified.time == 0 && userSpecified.GAST == 0
        warning('The 3D plot of Earth is made for current UTC time (the default). Umbra and ECEF axes are calculated for current time. If specific time is needed please specify "time" option');
    end

    %% creating figure

    npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
    alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible

    % image_file = 'http://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Land_ocean_ice_2048.jpg/1024px-Land_ocean_ice_2048.jpg';
    if strcmp(imageResolution, '1k')
            image_file = 'earthmap1k.jpg';
    elseif strcmp(imageResolution, '10k')
            image_file = 'earthmap10k.jpg';
    end

    % Mean spherical earth
    erad = Consts.rEarth;     % equatorial radius (meters)
    prad = Consts.rEarth;     % polar radius (meters)
    axisLength = 7500e3;
    %% check plotUnit

    if strcmp(plotUnit, 'km')
        erad = erad / 1000;
        prad = prad / 1000;
        axisLength = axisLength / 1000;
    end
    %% Create wireframe globe

    % Create a 3D meshgrid of the sphere points using the ellipsoid function

    [x, y, z] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);

    hold on;

    earth3D = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5 * [1 1 1]);

    % rotate Earth based on time
    hgx = hgtransform;
    set(hgx,'Matrix', makehgtform('zrotate',deg2rad(GAST)));
    set(earth3D,'Parent',hgx);


    %% Texturemap the globe

    % Load Earth image for texture map
    cdata = imread(image_file);

    % Set image as color data (cdata) property, and set face color to indicate
    % a texturemap, which Matlab expects to be in cdata. Turn off the mesh edges.
    set(earth3D, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');
    axis equal;
    axis off;
    view(figview)
    %% define sun direction and plot Shadow

    if umbra == 1
        [eSun, sunAzimuth, sunElev] = sun(time);
        % plot light as sun 
        light("Style","infinite","Position", eSun * 10000e20);
        material dull;  % More diffuse lighting

        % plot sun vector
        plot3([0 eSun(1) * axisLength], [0 eSun(2) * axisLength], [0 eSun(3) * axisLength], 'LineWidth', 2, 'Color', 'y')

    end

    if showAxes == 1
        % plot eci frame
        hold on
        plot3([0 1 * axisLength], [0 0 * axisLength], [0 0 * axisLength], 'LineWidth', 2, 'Color', 'r')
        plot3([0  0 * axisLength], [0  1 * axisLength], [0 0 * axisLength], 'LineWidth', 2, 'Color', 'g')
        plot3([0 0 * axisLength], [0 0 * axisLength], [0 1 * axisLength], 'LineWidth', 2, 'Color', 'b')

        % plot ecef frame
        xEcef = rotationZ(deg2rad(GAST)) * [1; 0; 0];
        yEcef = rotationZ(deg2rad(GAST)) * [0; 1; 0];
        zEcef = [0; 0; 1];

        xecefPlot = plot3([0, xEcef(1) * axisLength], [0, xEcef(2) * axisLength], [0, xEcef(3) * axisLength], 'LineWidth', 1, 'Color', 'r', 'LineStyle', '--');
        yecefPlot = plot3([0  yEcef(1) * axisLength], [0  yEcef(2) * axisLength], [0 yEcef(3) * axisLength], 'LineWidth', 1, 'Color', 'g', 'LineStyle', '--');
        zecefPlot = plot3([0 zEcef(1) * axisLength], [0 zEcef(2) * axisLength], [0 zEcef(3) * axisLength], 'LineWidth', 1, 'Color', 'b', 'LineStyle', '--');

    end


end
