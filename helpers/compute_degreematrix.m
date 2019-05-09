function [degree] = compute_degreematrix(obj,varargin)
% Returns a sparse matrix with the diagonal corresponding to the number of 
%   edge connected to each vertex. Matrix has a row and colum for each 
%   vertex such that degree(i,i) = number of connecting edges. Because
%   object is defined by faces, indegree and outdegree will always be the
%   same.
%
% Inputs:
% 	obj     -  object struct
%   optional args:
%      directed    -  assumes directed mesh (default)
%      undirected  -  assumes undirected mesh
% Outputs: 
%   degree  -  |v| x |v| sparse degree matrix
%
% Local Dependancies:
%   compute_edges
%
% Copyright (c) 2019 Nikolas Lamb
%

% Define flags and specifiers
flags       = ["directed" "undirected"];    
flagvals    = [1 0 1 0];
specs       = [];
specvals    = [];

% Parse input
if length(varargin) ~= 0
    [flagvals,specvals] = parse_function_input(flags,flagvals,specs,specvals,varargin);
end

% Compute adjacency matrix
if flagvals(1)
    adjacencies = compute_adjacencymatrix(obj,'directed');
else
    adjacencies = compute_adjacencymatrix(obj,'undirected');
end

% Degree is the sum of the row of the adjacency matrix
degree = sparse(1:length(adjacencies),1:length(adjacencies),full(sum(adjacencies,2)));

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