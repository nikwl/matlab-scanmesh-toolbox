function [vs,vidxs] = compute_find_vertices(obj,fidxs)
% Finds every vertex in an object referenced by any of a list of faces.   
%   Returns the faces as a list of points in 3D space. Optionally returns a
%   list of indices to their positions in obj.v.
%
% Inputs:
% 	 obj    -  object struct
% 	 fidxs  -  nx1 list of face indices
% Outputs: 
%    vs     -  nx3 list of vertices referenced by input faces
%    vidxs  -  nx1 list of vertex indices referenced by input faces
%
% Copyright (c) 2018 Nikolas Lamb
%

% List the index of every point referenced by the list of faces
vidxs = obj.f(fidxs,:);
vidxs = unique(vidxs(:));

% Extract vertices from the computed indices
vs = obj.v(vidxs,:);

end