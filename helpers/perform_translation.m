function [obj,transM] = perform_translation(obj,translation)
% Translates an object along a given axis
%
% Inputs:
% 	obj          -  obj struct to rotate
%   translation  -  1 x 3 vector of translation values or 4x4 translation matrix
% Outputs: 
%   obj          -  translated object struct
%   transM       -  homogenous 4x4 translation matrix 
%
% Copyright (c) 2018 Nikolas Lamb
%

% Parse input
if isvector(translation)
    % Generate tranformation matrix
    transM = [eye(3),[translation(1),translation(2),translation(3)]';zeros(1,3),1];
    
elseif ismatrix(translation)
    % Make sure matrix is a transform matrix
    assert(true(translation(1:3,1:3) == eye(4) && true(translation(4,1:4) == [0,0,0,1])),...
        'Input matrix must be a translation matrix (error, matrix must be identity except in column 4)');
    
    % Remap trnsformation matrix
    transM = translation;
    
end

% Translate object
obj.v = obj.v + translation;

end