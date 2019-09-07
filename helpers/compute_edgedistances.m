function [edgedists,edges] = compute_edgedistances(obj)
% Returns the distance between the vertices of all edges in an object.
%    Assumes the object is directed, and returns edges in the order that
%    they're refernced in the face list, such that edgedists(i) will
%    correspond to the distance between two points on face ceil(i/3). Also
%    optionally returns the list of edges in order of reference.
%
% Inputs:
% 	obj        -  object struct
% Outputs: 
%   edgedists  -  |e| x 1 list of edge distances
% 	edges      -  |e| x 2 list of edges
%
% Local Dependancies:
%   compute_edges
%
% Copyright (c) 2019 Nikolas Lamb
%

% Get edges
[edges] = compute_edges(obj,'stable');

% Get distance as norm of difference between vertex pairs
edgedists = cellfun(@norm, num2cell(obj.v(edges(:,1),:)-obj.v(edges(:,2),:), 2));

end