function rotationAnimationGif(satDimensions, qArray, targetDirectionArray)

    [verticesPositionsArray_B, linksArray] = calcParallelepidedVecticesPositions(satDimensions);

    % just to have a reasonable axis length for visualization
    axisLength = sum(satDimensions) / 3;
    xAxis = [[0; 0; 0], [1; 0; 0]] * axisLength;
    yAxis = [[0; 0; 0], [0; 1; 0]] * axisLength;
    zAxis = [[0; 0; 0], [0; 0; 1]] * axisLength;


    figure;
    plot3(xAxis(1,:), xAxis(2,:), xAxis(3,:), 'r', LineWidth=2);
    hold on;
    plot3(yAxis(1,:), yAxis(2,:), yAxis(3,:), 'g', LineWidth=2);
    hold on;
    plot3(zAxis(1,:), zAxis(2,:), zAxis(3,:), 'b', LineWidth=2);
    hold on;
    axis([-axisLength * 1.5 axisLength * 1.5 -axisLength * 1.5 axisLength * 1.5 -axisLength * 1.5 axisLength * 1.5]);
    axis square;
    xlabel('x, m');
    ylabel('y, m');
    zlabel('z, m');
    view(135, 30);
    gif('attitude_dynamics.gif','frame',gcf);

    for timeIdx = 1:size(qArray, 2)

        xAxisTransformed = rotateB2I(xAxis(:, 2), qArray(:, timeIdx));
        yAxisTransformed = rotateB2I(yAxis(:, 2), qArray(:, timeIdx));
        zAxisTransformed = rotateB2I(zAxis(:, 2), qArray(:, timeIdx));
 
        for vertexIdx = 1:size(verticesPositionsArray_B, 2)
            verticesPositionsArray_I(:, vertexIdx) = rotateB2I(verticesPositionsArray_B(:, vertexIdx), qArray(:, timeIdx));
        end

        bodyFrameX = plot3([0, xAxisTransformed(1)], [0, xAxisTransformed(2)], [0, xAxisTransformed(3)], 'r', LineWidth=1);
        bodyFrameY = plot3([0, yAxisTransformed(1)], [0, yAxisTransformed(2)], [0, yAxisTransformed(3)], 'g', LineWidth=1);
        bodyFrameZ = plot3([0, zAxisTransformed(1)], [0, zAxisTransformed(2)], [0, zAxisTransformed(3)], 'b', LineWidth=1);

        xVertices = verticesPositionsArray_I(1, :);
        yVertices = verticesPositionsArray_I(2, :);
        zVertices = verticesPositionsArray_I(3, :);
        satLocal = patch(xVertices(linksArray), yVertices(linksArray), zVertices(linksArray), 'k', 'facealpha', 0.1);

        targetDirection = plot3([0, targetDirectionArray(1, timeIdx) * axisLength], [0, targetDirectionArray(2, timeIdx) * axisLength], [0, targetDirectionArray(3, timeIdx) * axisLength], 'k', LineWidth=2);

        gif;
        if timeIdx < size(qArray, 2)
            delete(bodyFrameX);
            delete(bodyFrameY);
            delete(bodyFrameZ);
            delete(satLocal);
            delete(targetDirection);
        end

    end

end
