function [obj] = perform_rotation(obj,rot,axis)
% Rotates an object around a given axis. Transforms vertex normals after
%   rotation is applied.
%
% Inputs:
% 	obj   -  object struct to rotate
% 	rot   -  rotation in degrees
% 	axis  -  axis to rotate about ('x','y','z')
% Outputs: 
%   obj   -  rotated object struct
%
% Copyright (c) 2018 Nikolas Lamb
%

% Calculate rotation matrix from axis of rotation
switch axis
    case 'x'
        rotM = [...
            1, 0, 0;...
            0, cosd(rot), -sind(rot);...
            0, sind(rot), cosd(rot)];
    case 'y'
        rotM = [...
            cosd(rot), 0, sind(rot);...
            0, 1, 0;...
            -sind(rot), 0, cosd(rot)];
    case 'z'
        rotM = [...
            cosd(rot), -sind(rot), 0;...
            sind(rot), cosd(rot), 0;...
            0, 0, 1];
end

% Compute matrix inverse transpose to transform normals
rotMnorm = inv(rotM)';

% Apply rotation matrix to each vertex
for i = 1:length(obj.v)
   obj.v(i,:) = rotM * obj.v(i,:)';
   obj.vn(i,:) = rotMnorm * obj.vn(i,:)';
end

end