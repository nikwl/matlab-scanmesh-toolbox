function [adjacencies] = compute_adjacencymatrix(obj,varargin)
% Returns a sparse matrix corresponding to vertex connections on the
%   object. To find the adjacencies of the i'th vertex, use
%   adjacencies(i,:). If a vertex has no adjacencies that row will be
%   empty.  
%
% Inputs:
% 	obj          -  object struct
%   optional args:
%      directed    -  assumes directed mesh (default)
%      undirected  -  assumes undirected mesh, ie symmetric edges
% Outputs: 
%   adjacencies  -  |v| x |v| sparse adjacency matrix
%
% Local Dependancies:
%   compute_edges
%
% Copyright (c) 2019 Nikolas Lamb
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

% Compute edges
if flagvals(1)
    edges = compute_edges(obj,'directed');
else
    edges = compute_edges(obj,'undirected');
end

% First edge col is rows, second edge col is columns 
adjacencies = sparse(edges(:,1),edges(:,2),ones(length(edges),1));

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

% OTHER METHODS:
%
% Fast for directed mesh
% [adjacencies] = compute_adjacencymatrix(obj)
% facesT = obj.f';
% facesSwT =[obj.f(:,2),obj.f(:,3),obj.f(:,1)]';
% 
% adjacencies = sparse(facesT(:),facesSwT(:),ones(length(obj.f)*3,1));
% end