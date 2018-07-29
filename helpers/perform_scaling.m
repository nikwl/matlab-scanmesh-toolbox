function [obj] = perform_scaling(obj,scale)
% Scales an object by a given percentage, without recentering.
%
% Inputs:
% 	obj    -  obj struct to rotate
% 	scale  -  scale percentage
% Outputs: 
%   obj    - scaled object 
%
% Copyright (c) 2018 Nikolas Lamb
%

% Scale object
obj.v = obj.v * scale;

end