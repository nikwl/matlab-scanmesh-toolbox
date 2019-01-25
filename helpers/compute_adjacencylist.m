function [adjacencies] = compute_adjacencylist(obj)
% Returns a cell array representing a list of all vertex connections in an
%   object. Connections are returned as a list of lists. To find the
%   adjacencies of the i'th vertex in the object, use 'adjacencies{i}'.
%   Will create empty entries for unreferenced vertices. Assumes graph is
%   directed.
%
% Inputs:
% 	obj          -  object struct
% Outputs: 
%   adjacencies  -  mxn cell array of vertex connections
%
% Copyright (c) 2018 Nikolas Lamb
%

% Initializes array with this many connections (ive never seen more than 14)
mostConnections = 15;

% Compute and sort edges
facesT = obj.f';
facesSwT =[obj.f(:,2),obj.f(:,3),obj.f(:,1)]';
edges = sortrows([facesT(:),facesSwT(:)]);

% Extract the greatest index, this is the length of the list
greatestIndex = max(edges(:,1));

% Initialize adjacencies and index counter
idxs = ones(greatestIndex,1);
adjacenciesWZeros = zeros(greatestIndex,mostConnections);

% Add second vertex to the last unocupied column at row first vertex
for i = 1:length(edges)
    id = edges(i,1);
    adjacenciesWZeros(id,idxs(id)) = edges(i,2);
    idxs(id) = idxs(id) + 1;
end

% Preallocate adjacency list
adjacencies{greatestIndex} = [];

% Remove zeros
for i = 1:greatestIndex
    adjacencies{i} = [nonzeros(adjacenciesWZeros(i,:))]';
end

% Transpose adjacency list because it makes more sense that way
adjacencies = adjacencies';

end