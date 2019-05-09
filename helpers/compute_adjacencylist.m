function [adjacencies] = compute_adjacencylist(obj,varargin)
% Returns a cell array representing a list of all vertex connections in an
%   object. Connections are returned as a list of lists. To find the
%   adjacencies of the i'th vertex in the object, use 'adjacencies{i}'.
%   Will create empty entries for unreferenced vertices.
%
% Inputs:
% 	obj          -  object struct
%   optional args:
%      directed    -  assumes directed mesh (default)
%      undirected  -  assumes undirected mesh
% Outputs: 
%   adjacencies  -  |v| cell array of vertex connections
%
% Copyright (c) 2018 Nikolas Lamb
%

% Define flags and specifiers
flags       = ["directed" "undirected"];    
flagvals    = [1 0];
specs       = [];
specvals    = [];

% Parse input
if length(varargin) ~= 0
    [flagvals,specvals] = parse_function_input(flags,flagvals,specs,specvals,varargin);
end

% Initializes array with this many connections (ive never seen more than 14)
mostConnections = 15;

% Compute edges
if flagvals(1)
    edges = compute_edges(obj,'directed','sorted');
else
    edges = compute_edges(obj,'undirected');
end

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

function [flagdef,specdef] = parse_function_input(flags,flagdef,specs,specdef,v)

flagvals = zeros(1,length(flags));
specvals = zeros(1,length(specs));

i = 1;
while i <= length(v)
    % Get the location of the flag or specifier in the provided list
    found = strcmpi(v{i},[flags,specs]);
    
    % Identifier not found
    if ~any(found)
        error('Unknown flag or specifier');
    end
    foundloc = find(found);
    
    % Identifier is a flag
    if foundloc <= length(flags)
        flagvals(foundloc) = 1;        
    else % Identifier is a specifier
        if i < length(v)
            if ~any(strcmpi(v{i+1},[flags,specs]))
                specvals(foundloc-length(flags)) = v{i+1};
                i = i + 2;
                continue
            else
                error('Specifier given with no value');
            end
        else
            error('Specifier given with no value');
        end
    end
    i = i + 1;
end

% Conditionals
if flagvals(1) || flagvals(2) 
    if flagvals(1) && flagvals(2) 
        error('Cant be both directed and undirected');
    end
    flagdef(1) = flagvals(1);
    flagdef(2) = flagvals(2);
end

end