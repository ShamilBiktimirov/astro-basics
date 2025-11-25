function uProcessed = controlVectorSaturationProcessing(uInitial, type, threshold)

    % Input:
    % uInitial: a control vector [3x1]
    % type: 'norm' or 'component'
    % threshold: maximum for control vector norm or a component

    % Output:
    % uProcessed: scaled control vector [3x1]

    % 'norm' is appicable when control is limited by the magnitude of the
    % control input vector -  applicable for orbit control, mostly

    % 'component' is applicable where there is a limitation to a maximum
    % absolute value of a control input component [ux, uy, uz], applicable for control with reaction wheels or magnetic coils

    uProcessed = uInitial;

    switch type
        case 'norm'
            if norm(uInitial) > threshold
                uProcessed = uInitial / norm(uInitial) * threshold;
            end
        case 'component'
            if any(abs(uInitial) > threshold)
                uProcessed = uInitial / max(abs(uInitial)) * threshold;
            end
    end


end
