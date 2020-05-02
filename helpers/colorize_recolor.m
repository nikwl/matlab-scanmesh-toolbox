function [obj] = colorize_recolor(obj,color)
% Colors the vertices of the object based on the local curvature by,
%   for each vertex v1, computing the average of angles between v1 + vn, 
%   v1, and all adjacent vertices.
%
% Inputs:
% 	obj    -  obj struct to colorize
%   color  -  matrix, vector, or char defining the desired color. If matrix
%      must be |v| x 3. If vector must be 3 x 1. If char, must be color in
%      matlab colorspec.
% Outputs: 
%   obj    -  colorized obj struct
%
% Copyright (c) 2019 Nikolas Lamb
%

if isempty(color)
    error('Color was of unknown type. Specify color as a matrx, vector or character.')
end

if ischar(color)
    switch color
        case 'y'
            color = [1 1 0];
        case 'm'
            color = [1 0 1];
        case 'c'
            color = [0 1 1];
        case 'r'
            color = [1 0 0];
        case 'g' 
            color = [0 1 0];
        case 'b'
            color = [0 0 1];
        case 'w' 
            color = [1 1 1];
        case 'k'
            color = [0 0 0];
        otherwise 
            error('Unknown color character.')
    end
    obj.vc = repmat(color,[size(obj.v,1),1]);
elseif isvector(color)
    if length(color) == 3
        obj.vc = repmat(color,[size(obj.v,1),1]);
    else
        error('Color vector is incorrect size. Must be 1 x 3')
    end
elseif ismatrix(color)
    length(color)
    if size(color) == size(obj.vc)
        obj.vc = color;
    else
        error('Color matrix is incorrect size. Must be |v| x 3.');
    end
else
    error('Color was of unknown type. Specify color as a matrx, vector or character.')
end
    
end