function plotEarth(varargin)

% this function plots 3D Earth with different options
% the user can specifiy the Julian Date or the GAMST for the plot
% if time is not provided, the default will be 'now'
% umbra will be added to the plot by default based on time
% user can switch off umbra, see below the optional inputs


% optional inputs:

% plotUnit: Earth plot unit
% plotUnit: can be 'm' or 'km', default is 'm'

% imageResolution: Earth surface image resoultion
% imageResolution: can be '1k' or '10k', default is '1k'

% timeJD: Julian Date can be specified as datetime or Julian Date
% timeGAST: Greenwich Apparent Sidereal Time, deg

% umbra: Earth shadow
% umbra: can be 0 or 1, by default is 1 which means shadow is on. 


%% checking optional inputs
        parser = inputParser;

        defaultUnit = 'm';
        defaultImageRes = '1k';
        defaultTimeJD = juliandate(datetime('now'));
        defaultTimeGAST = JD2GAST(defaultTimeJD);
        defaultUmbra = 1;

        addOptional(parser,'plotUnit', defaultUnit);
        addOptional(parser,'imageResolution', defaultImageRes);
        addOptional(parser,'timeJD', defaultTimeJD);
        addOptional(parser,'timeGAST', defaultTimeGAST);
        addOptional(parser,'umbra', defaultUmbra);


        % Parse the inputs
        parse(parser, varargin{:});
        
        args = parser.Results;
        usedDefaults = parser.UsingDefaults;
        
        % Determine what the user specified
        userSpecified.timeJD = ~ismember('timeJD', usedDefaults);
        userSpecified.timeGAST = ~ismember('timeGAST', usedDefaults);

        % Extract parsed values
        plotUnit = args.plotUnit;
        imageResolution = args.imageResolution;
        umbra = args.umbra;


        % check timeJD and timeGD
        if userSpecified.timeJD == 0 && userSpecified.timeGAST == 0
            timeJD = args.timeJD;
            timeGAST = args.timeGAST;
            
        elseif userSpecified.timeJD == 1 && userSpecified.timeGAST == 0

            timeJD = args.timeJD;

           % Check if timeJD is provided as datetime or Julian Date
            if isa(timeJD, 'datetime')
                % If timeJD is a datetime, convert it to Julian Date
                timeJD = juliandate(timeJD);
            elseif ~isnumeric(timeJD)
                error('The timeJD must be either a datetime or a numeric Julian date.');
            end

            timeGAST = JD2GAST(timeJD);

        elseif userSpecified.timeJD == 0 && userSpecified.timeGAST == 1
                error('timeJD is not provided');

        elseif userSpecified.timeJD == 1 && userSpecified.timeGAST == 1

            % If both timeJD and timeGD are provided, check if they match
            timeJD = args.timeJD;

             % Check if timeJD is provided as datetime or Julian Date
            if isa(timeJD, 'datetime')
                % If timeJD is a datetime, convert it to Julian Date
                timeJD = juliandate(timeJD);
            elseif ~isnumeric(timeJD)
                error('The timeJD must be either a datetime or a numeric Julian date.');
            end

            timeGAST = args.timeGAST;

            % Convert timeGD back to Julian Date to check if they match
            calculatedGD = JD2GAST(timeJD); % deg
            
            if abs(calculatedGD - timeGAST) > 1e-5  % Small tolerance
                error('The timeJD and timeGD values do not match. Please provide consistent values.');
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

        if userSpecified.timeJD == 0 && userSpecified.timeGAST == 0
            warning('The 3D plot of Earth is at current time (the default) and umbra is also based on it, if you need specific time please specify timeJD in the input')
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

    %% Create wireframe globe

    % Create a 3D meshgrid of the sphere points using the ellipsoid function

    [x, y, z] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);

    globe = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5 * [1 1 1]);

    % rotate Earth based on time
    hgx = hgtransform;
    set(hgx,'Matrix', makehgtform('zrotate',deg2rad(timeGAST)));
    set(globe,'Parent',hgx);


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
    axis off;

    %% define sun direction and plot Shadow

    if umbra == 1
        [eSun, sunAzimuth, sunElev] = sun(timeJD);
        % plot light as sun 
        light("Style","infinite","Position", eSun * 10000e20);
        material dull;  % More diffuse lighting
    end

end
