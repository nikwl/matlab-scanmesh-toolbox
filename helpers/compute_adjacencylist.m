function [adjacencies] = compute_adjacencylist(obj)
% Returns a cell array representing a list of all vertex connections in an
%   object. Connections are returned as a list of lists. To find the
%   adjacencies of the i'th vertex in the object, use 'adjacencylist{i}'.
%   Will create empty entries for unreferenced vertices.
%
% Inputs:
% 	obj        -  object struct
% Outputs: 
%   divisions  -  mxn cell array of vertex connections
%
% Copyright (c) 2018 Nikolas Lamb
%

% Transpose and shift faces
facesT = obj.f';
facesSwT =[obj.f(:,2),obj.f(:,3),obj.f(:,1)]';

% Compute and sort facepairs
fpairs = [facesT(:),facesSwT(:)];
fpairsSorted = sortrows(fpairs);

% Preallocate adjacency list
for i = 1:max(fpairsSorted(:,1))
    adjacencies{i} = [];
end

% Initialize loop vairables
j = fpairsSorted(1,1);

% Initailize adjacency list
adjacencies{j}(end+1) = fpairsSorted(1,2);

% If an index is repeated, add to the current cell, else start a new cell
for i = 2:length(fpairsSorted)
    last = fpairsSorted(i-1,1);
    if last == fpairsSorted(i,1)
        adjacencies{j}(end+1) = fpairsSorted(i,2);
    else
        j = fpairsSorted(i,1);
        adjacencies{j}(end+1) = fpairsSorted(i,2);
    end
end

% Transpose adjacency list because it makes more sense that way
adjacencies = adjacencies';

end