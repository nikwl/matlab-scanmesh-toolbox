function [transformedobj] = perform_manual_align(mobileobj,gluedobj)
% Manually select six points to correctly align an object. After
%   selecting six points, icp is run automatically to snap objects. 
%
% Inputs:
% 	brokenobj       -  obj struct to be aligned
% 	wholeobj        -  obj struct to align to
% Outputs: 
%   transformedobj  -  brokenobj struct, aligned
%
% Internal Functions:
%   pointDistance
%   anglePoints
%   angleVectors
%   matrixTransform
%   angleAboutLine
%   angleAboutVector
%
% Local Dependancies:
%   perform_rotation
%   perform_matrix_transform
%   vis_object
%
% Copyright (c) 2018 Nikolas Lamb
%

% Display instructions
fprintf('Shift-select points on the Broken and Whole object that correspond to on another\n');
fprintf('Alternate selecting points on the first two plots to maintain correct correspondances\n');
fprintf('The Alignment plot will be updated with your incremental changes\n');
fprintf('Once 3 correspondances have been made on each object, icp will run automatically\n');
fprintf('If you select incorrectly, delete a point and then reselect\n');
fprintf('Close the figure when the alignment is satisfactory\n');

% Copy brokenobj to presevere inital state
transformedobj = mobileobj;

% Create figure and subplots
fig = figure;
subplot(1,3,1);
title('Glued Object')
vis_object(gluedobj,'Tag','a');
subplot(1,3,2);
title('Mobile Object')
vis_object(mobileobj,'Tag','b');
sp3 = subplot(1,3,3);
title('Alignment')
vis_object(gluedobj,'Tag','c');
[o,l] = vis_object(transformedobj,'color','r','rescale',false,'Tag','d');
             
% Assign information handle
dcm_fig = datacursormode(fig);

% Init variables
updatePlots = true;
lenInfoPrev = 0;
transforms = [];

% Update data and redraw figure while open
while ishandle(fig)
    % Get cursor info from plots
    info = getCursorInfo(dcm_fig);
    
    if lenInfoPrev ~= length(info)
        updatePlots = true;
    end
    
    % Make sure that some points have been selected
    if ~isempty(info) && updatePlots
        
        % Extract point indices from patch tags
        patches = vertcat(info(:).Target);
        tags = vertcat(patches(:).Tag);
        wholeidx = find(tags == 'a');
        brokenidx = find(tags == 'b');
        
        lenWholeIdx = length(wholeidx);
        lenBrokenIdx = length(brokenidx);     
        
        % Update plot if points exist and points have changed
        if (lenWholeIdx >= 3) && (lenBrokenIdx >= 3)

            % Extract keypoints
            w = waitbar(0,'Transforming Inputs');

            % Transform keypoints
            wholepos = matrixTransform(flipud(vertcat(info(wholeidx).Position)),transforms);
            brokenpos = matrixTransform(flipud(vertcat(info(brokenidx).Position)),transforms);

            % How much to move the object
            rotAngle = angleAboutLine(wholepos(3,:),brokenpos(3,:),wholepos(1,:),wholepos(2,:));
            
            % Move the object
            transformedobj = perform_matrix_transform(mobileobj,transforms);
            
            % Extract two rotations, alignment depends on vector direction
            transformedobj1 = perform_rotation(transformedobj,rotAngle,'Axis',[wholepos(2,:);wholepos(1,:)]);
            transformedobj2 = perform_rotation(transformedobj,180-rotAngle,'Axis',[wholepos(2,:);wholepos(1,:)]);
            
            % Compute object distance and sum
            waitbar(.1,w,'Extracting Correct Transformation');
            [~,d11] = knnsearch(transformedobj1.v,gluedobj.v);
            [~,d12] = knnsearch(gluedobj.v,transformedobj2.v);
            [~,d21] = knnsearch(transformedobj2.v,gluedobj.v);
            [~,d22] = knnsearch(gluedobj.v,transformedobj2.v);
            d1 = sumsqr([d11;d12]);
            d2 = sumsqr([d21;d22]);
            
            waitbar(.4,w,'Generating Point Clouds');
            
            % Generate whole pointcloud for icp alignment
            wholeptc = pointCloud(gluedobj.v);
            
            % Determine which transformed pointcloud is correct
            if d1 < d2
                transformedptc = pointCloud(transformedobj1.v);
            else
                transformedptc = pointCloud(transformedobj2.v);
            end
            
            waitbar(.5,w,'Performing ICP Snap');
            
            % Align using icp
            [~,transformedptc] = pcregrigid(transformedptc,wholeptc);
            transformedobj.v = transformedptc.Location;
            
            waitbar(1,w,'Performing ICP Snap');
            delete(w)
            
        elseif (lenWholeIdx >= 2) && (lenBrokenIdx >= 2)

            % Extract keypoints
            w = waitbar(0,'Transforming Inputs');

            % Transform keypoints
            wholepos = matrixTransform(flipud(vertcat(info(wholeidx).Position)),transforms);
            brokenpos = matrixTransform(flipud(vertcat(info(brokenidx).Position)),transforms);
            
            % How much to move the object
            rotMatrix = angleAboutVector(wholepos(2,:)-wholepos(1,:),brokenpos(2,:)-wholepos(1,:));
            
            % Move the object
            waitbar(.5,w,'Transforming Object');
            transformedobj = perform_matrix_transform(mobileobj,transforms);
            [transformedobj,transforms{2}] = perform_rotation(transformedobj,rotMatrix,'Origin',wholepos(1,:));
            
            waitbar(1,w,'Transforming Object');
            delete(w)
            
        elseif (lenWholeIdx >= 1) && (lenBrokenIdx >= 1)

            % Extract keypoints
            w = waitbar(0,'Transforming Inputs');
            wholepos = flipud(vertcat(info(wholeidx).Position));
            brokenpos = flipud(vertcat(info(brokenidx).Position));
            
            % How much to move the object
            transforms{1} = [eye(3),[wholepos(1,:) - brokenpos(1,:)]';[zeros(1,3),1]];
            
            % Move the object
            waitbar(.5,w,'Transforming Object');
            transformedobj = perform_matrix_transform(mobileobj,transforms);
            
            waitbar(1,w,'Transforming Object');
            delete(w)
        end

        % Grab the alignment subplot handle
        sp3 = subplot(1,3,3);
        
        % Delete the current patch and open new one
        delete(o)
        delete(l)
        [o,l] = vis_object(transformedobj,'color','r','rescale',false,'Tag','d');  
        
        % Plot has been updated
        updatePlots = false; 
        
    end
    
    % Update length monitor and redraw figure
    lenInfoPrev = length(info);
    drawnow
end

end

function [rotM] = angleAboutVector(v1,v2)
% Returns a rotation matrix which rotates one vector (v1) onto another 
%   vector (v2) about the origin. 
%
% Inputs:
% 	v1    -  vector to be rotated
%   v2    -  vector to rotate onto
% Outputs:
%   rotM  -  rotation matrix
%
% Note: 
%   custom rotation axis formula source https://math.stackexchange.com/questions/180418/calculate-rotation-matrix-to-align-vector-a-to-vector-b-in-3d
%
% Copyright (c) 2018 Nikolas Lamb
%

% Normalize vectors
v1 = v1./norm(v1);
v2 = v2./norm(v2);

% Checks if vectors are linearly dependant
if (angleVectors(v1,v2) == 0)
    rotM = eye(3);
    return  
elseif (angleVectors(v1,v2) == 180)
    rotM = -eye(3);
    return
end 

% Execute algorithm?
v = cross(v1,v2);
c = dot(v1,v2);

ssv = [0, -v(3), v(2);...
       v(3), 0, -v(1);...
      -v(2), v(1), 0];
  
rotM = eye(3) + ssv + (ssv * ssv) * (1 / (1 + c));

rotM = rotM';

end

function [angle] = angleAboutLine(p1,p2,l1,l2)
% Returns the angle between p1 and p2 as projected over the line defined by
%   points l1 and l2, favoring p1. First finds the closest points to p1 and
%   p2 that lay on the line. Then shifts p2 by the difference between those
%   points. Then computes the angle from p1 to p2shifted through the
%   closest point on the line to p1. 
%
% Inputs:
% 	p1     -  initial point
%   p2     -  ending point
%   l1     -  first point defining the line
%   l2     -  second point defining the line
% Outputs: 
%   angle  -  angle between p1 and p2 through line
%
% Note: 
%   custom rotation axis formula source https://en.wikipedia.org/wiki/Rotation_matrix
%
% Copyright (c) 2018 Nikolas Lamb
%

% Compute line vector and normalize
lv = (l2-l1);
lv = lv/norm(lv);

% Compute closest point on line to p1 and p2
linep1 = lv * dot(p1,lv);
linep2 = lv * dot(p2,lv);

% Compute p2 shifted towards p1 along the line
p2shift = p2 + (linep1-linep2);

% Compute the angle between the points
angle = anglePoints(p1, linep1, p2shift);

end

function [vs] = matrixTransform(vs,trans)
% Applies a list of transformation matrices. Transformations are applied in
% the order they are given. 

% How many transformations to apply
numtrans = length(trans);

% Multiply matricies if multiple transformations
if numtrans > 1
    transM = trans{1};
    trans(1) = [];
    for i = 1:numtrans-1
        transM = trans{i} * transM;
    end
else
    transM = trans{1};
end

% Extract vertices, transpose, and homogenize
dim = size(vs);
hvs = [vs,zeros(dim(1),1)];
hvs = num2cell(hvs',1);

% Apply transformations in parallel
hvs = cellfun(@(x) transM*x,hvs,'UniformOutput',false);

% Convert back to array and transpose
hvs = cell2mat(hvs);
hvs = hvs';

% Return to obj struct
vs = hvs(:,1:3);

end

function [angle] = angleVectors(v1,v2)
% Returns the angle between two vectors using law of cosines. Angle is in
% degrees.

% Compute angle of vectors 
angle = acosd(dot(v1,v2)/(norm(v1)*norm(v2)));

end

function [angle] = anglePoints(p1,p2,p3)
% Returns the angle between three points using law of cosines. Assumes pt2
% is the center point. Angle is in degrees.
%
% Inputs:
% 	p1     -  1x3 point in 3D space
% 	p2     -  1x3 point in 3D space
%	p3     -  1x3 point in 3D space
% Outputs: 
% 	angle  -  angle from pt1 to pt3 through pt2 in degrees
%
% Copyright (c) 2018 Nikolas Lamb
%

% Compute distances between each point
d12 = pointDistance(p1,p2);
d23 = pointDistance(p2,p3);
d31 = pointDistance(p3,p1);

% Use law of cosines to compute angle
angle = real(acosd((d12.^2 + d23.^2 - d31.^2)/(2.*d12.*d23)));

end

function [dist] = pointDistance(pt1,pt2)
% Returns the distacne between 2 3d points using the pythagorean theorem. 

% Evaluate the distance between 2 points, sqrt(a^2+b^2+c^2)=distance
dist = sqrt((pt1(1) - pt2(1))^2 + (pt1(2) - pt2(2))^2+(pt1(3) - pt2(3))^2);

end