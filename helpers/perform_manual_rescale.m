function [objtoscale] =  perform_manual_rescale(objtoscale,refobj,refdist)
% Manually select two points on an object for scaling to predetermined
%    ground-truth. Useful for rescaling scans of objects. Requires two
%    input objects, one to which the rescale will be applied and one to
%    provide the rescale amount via a 'reference' of known size. Optionally 
%    these can be the same object. Relies on helper function vis_object.
%
% Inputs:
% 	objtoscale  -  object struct to be scaled
% 	refobj      -  object struct containing reference object
%   refdist     -  reference distance corresponding to selected points
% Outputs: 
%   objtoscale  - object struct rescaled
%
% Internal Functions:
%   pointDistance
%
% Local Dependancies:
%   vis_object
% 
% Copyright (c) 2018 Nikolas Lamb
%

% Display instructions
fprintf('Shift-select two points on the object that correspond to the reference distance\n');
fprintf('Close the figure when points have been selected\n');

% Create a new figure
fig = figure;
vis_object(refobj)
view(max(refobj.v))

% Assign information handle
dcm_fig = datacursormode(fig);

% Update data and redraw figure while open
while ishandle(fig)
    info = getCursorInfo(dcm_fig);
    drawnow
end

% Compute the distance between selected points
objDist = pointDistance(info(1).Position,info(2).Position);

% Compute the scale factor between the computed distances
scaleFactor = refdist/objDist;

% Adjust the input object by the computed scale factor
objtoscale.v = objtoscale.v .* scaleFactor;

end

function [dist] = pointDistance(pt1,pt2)
% Returns the distacne between 2 3d points using the pythagorean theorem. 

% Evaluate the distance between 2 points, sqrt(a^2+b^2+c^2)=distance
dist = sqrt((pt1(1) - pt2(1))^2 + (pt1(2) - pt2(2))^2+(pt1(3) - pt2(3))^2);

end