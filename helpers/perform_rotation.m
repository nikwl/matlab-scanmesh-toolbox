function [obj,rotM] = perform_rotation(obj,rotation,varargin)
% Rotates an object around a given axis. Transforms vertex normals after
%   rotation is applied.
%
% Inputs:
% 	obj       -  obj struct to rotate
% 	rotation  -  rotation (in degrees). this variable can be: integer (in
% 	   this case specify an axis using optional args), 1x3 array (rotation
% 	   for each axis), or a 4x4 rotation matrix
% 	optional args:
%      Origin  -  1x3 rotate about a given point
%      Order   -  1x3 order in which to apply rotations
%      Axis    -  2x3 two points defining a custom axis, [origin; up]
% Outputs: 
%   obj       -  rotated obj struct
%   rotM      -  homogenous 4x4 rotation matrix
%
% Note: 
%   custom rotation axis formula source https://en.wikipedia.org/wiki/Rotation_matrix
%
% Copyright (c) 2018 Nikolas Lamb
%

% Create input parser and init default values
p = inputParser;
defaultOrigin = [0,0,0];
defaultOrder = [1,2,3];
defaultAxis = [[0,0,1];[0,0,0]];

% Add input parameters and parse
addRequired(p,'obj',@isstruct);
addRequired(p,'rotation', @(x) ismatrix(x) || isvector(x) || isscalar(x));
addParameter(p,'Origin',defaultOrigin,@isvector);
addParameter(p,'Order',defaultOrder,@isvector);
addParameter(p,'Axis',defaultAxis,@ismatrix);
parse(p,obj,rotation,varargin{:});

% Reassign variable names
obj = p.Results.obj;
rotation = p.Results.rotation;
origin = p.Results.Origin;
order = p.Results.Order;
axis = p.Results.Axis;

% Parse input
if isscalar(rotation)
    % Translate object to point on axis
    origin = axis(1,:) + origin;
    
    % Extract vector
    v = axis(1,:) - axis(2,:);
    v = v/norm(v);
    
    % Compute skew symmetric matrix
    ssv = [0, -v(3), v(2);...
       v(3), 0, -v(1);...
      -v(2), v(1), 0];

    % Compute rotaion matrix
    rotM = cosd(rotation) * eye(3) + sind(rotation) * ssv + (1 - cosd(rotation)) * kron(v,v');
    
elseif isvector(rotation)
    % Extract rotations
    xrot = rotation(1);
    yrot = rotation(2);
    zrot = rotation(3);
    
    % Generate rotation matrices
    rotX = [1, 0, 0;...
            0, cosd(xrot), -sind(xrot);...
            0, sind(xrot), cosd(xrot)];
        
    rotY = [cosd(yrot), 0, sind(yrot);...
            0, 1, 0;...
            -sind(yrot), 0, cosd(yrot)];
        
    rotZ = [cosd(zrot), -sind(zrot), 0;...
            sind(zrot), cosd(zrot), 0;...
            0, 0, 1];
        
    % Apply rotations in the correct order
    rotMs = {rotX,rotY,rotZ};
    rotM = rotMs{order(1,1)} * rotMs{order(1,2)} * rotMs{order(1,3)};
    
elseif ismatrix(rotation)
    % Make sure matrix is a rotation matrix
    assert(det(rotation) == 1,...
        'Input matrix must be a rotation matrix (error, det(matrix) /= 1)');
    
    % Just port matrix
    rotM = rotation(1:3,1:3);
end

% Translate object to new origin
obj.v = obj.v - origin;
    
% Compute matrix inverse transpose to transform normals
rotMnorm = inv(rotM)';

% Extract vertices, transpose, and homogenize 
vs = obj.v;
vns = obj.vn;
vs = num2cell(vs',1);
vns = num2cell(vns',1);

% Apply transformations in parallel
vs = cellfun(@(x) rotM*x,vs,'UniformOutput',false);
vns = cellfun(@(x) rotMnorm*x,vns,'UniformOutput',false);

% Convert back to array and transpose
vs = cell2mat(vs);
vns = cell2mat(vns);
vs = vs';
vns = vns';

% Return to obj struct
obj.v = vs;
obj.vn = vns;

% Translate object back to old origin
obj.v = obj.v + origin;

% Convert to homogenous coordinates
rotM = [rotM,zeros(3,1);zeros(1,3),1];

end