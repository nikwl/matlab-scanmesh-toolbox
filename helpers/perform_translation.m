function [obj] = perform_translation(obj,dist,axis)
% Translates an object along a given axis. 
%
% Inputs:
% 	obj    -  obj struct to rotate
% 	dist   -  translation distance
% 	axis   -  axis to translate along about ('x','y','z')
% Outputs: 
%   obj   -  rotated object struct
%
% Copyright (c) 2018 Nikolas Lamb
%

% Translate the object along given axis
switch axis
    case 'x'
        obj.v(:,1) = obj.v(:,1) + dist;
    case 'y'
        obj.v(:,2) = obj.v(:,2) + dist;
    case 'z'
        obj.v(:,3) = obj.v(:,3) + dist;
end

end