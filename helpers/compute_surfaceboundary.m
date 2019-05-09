function [boundaries] = compute_surfaceboundary(obj)
% Returns all the surface boundaries on an object as ordered lists of 
%   vertices. A surface boundary is made up of edges that occur once on the
%   object.  
% 
% Inputs:
% 	obj         -  object struct
% Outputs: 
%   boundaries  -  cell array of ordered lists of vertices that lie on the
%     surface boundary of the object
%
% Local Dependancies:
%   compute_edges
%
% Copyright (c) 2019 Nikolas Lamb
%

% Compute edges
edges = compute_edges(obj,'directed');

% Compute symmetric edges
symmetricEdges = [edges;edges(:,2),edges(:,1)];

% Find unique edges
[~,u,~] = unique(symmetricEdges,'rows');

% Remove out all edges that occur more than once
boundaryEdgeIdxs = setdiff(u,[1:length(obj.f*3)*3]) - length(obj.f*3)*3;
boundaryEdges = edges(boundaryEdgeIdxs,:);

% Initialize loop vairables
j = 1;
k = 1;

% Initialize boundary
boundaries = [];

% Assign the starting edge to the first boundary 
boundaries{j} = boundaryEdges(1,1);
k = k + 1;
boundaries{j}(k) = boundaryEdges(1,2);
boundaryEdges(1,:) = [];

% Compute the traces
while ~isempty(boundaryEdges)
    
    % Find left index that connects to current edge
    [idx1,~] = find(boundaryEdges(:,1) == boundaries{j}(k));
    
    % Build the list and delete the edge, else create new list 
    if ~isempty(idx1)
        idx1 = idx1(1);
        k = k + 1;
    	boundaries{j}(k) = boundaryEdges(idx1,2);
        boundaryEdges(idx1,:) = [];
    else 
        k = 1;
        j = j + 1;
        boundaries{j}(k) = boundaryEdges(1,1);
        k = k + 1;
        boundaries{j}(k) = boundaryEdges(1,2);
        boundaryEdges(1,:) = [];
    end
end

% Transpose boundaries because it makes more sense that way
boundaries = boundaries';

end
