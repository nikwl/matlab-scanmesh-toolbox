function [obj,scaleM] = perform_scaling(obj,scale)
% Scales an object
%
% Inputs:
% 	obj     -  obj struct to rotate
% 	scale   -  1 x 3 vector of scale values or 4x4 scale matrix
% Outputs: 
%   obj     -  scaled object struct
%   scaleM  -  homogenous 4x4 scaling matrix
%
% Copyright (c) 2018 Nikolas Lamb
%

% Parse input
if isvector(scale)
    % Generate tranformation matrix
    scaleM = [scale(1), 0, 0, 0;...
              0, scale(2), 0, 0;...
              0, 0, scale(3), 0;...
              0, 0, 0, 1];
    scaleM = [scaleM,zeros(3,1);zeros(1,3),1];
    
elseif ismatrix(scale)
    % Make sure matrix is a transform matrix
    assert(true(scale(1,2:4) == [0,0,0]) && true(scale(2,[1,3:4]) == [0,0,0]) && true(scale(3,[1:2,4]) == [0,0,0]) && true(scale(4,1:3) == [0,0,0]),...
        'Input matrix must be a translation matrix (error, matrix must be identity except along diagonal)');
    
    % Remap trnsformation matrix
    scaleM = scale;
    
    % Extract individual scales
    scale = diag(scale,3);
end

% Scale object
obj.v = obj.v * scale;

end