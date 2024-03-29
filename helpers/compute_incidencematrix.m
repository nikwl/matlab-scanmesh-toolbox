function [incidence] = compute_incidencematrix(obj,varargin)
% Returns a sparse matrix corresponding to edge incidence. Matrix has a row
%   for each vertex and a column for each edge, and (v,e) = 1 iff v is
%   incident upon edge e. 
%
% Inputs:
% 	obj          -  object struct
%   optional args:
%      directed    -  assumes directed mesh (default)
%      undirected  -  assumes undirected mesh, ie symmetric edges
% Outputs: 
%   incidence    -  |v| x |e| sparse incidence matrix
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
specvals    = {[]};

% Parse input
if ~isempty(varargin)
    [flagvals,specvals] = parse_function_input(flags,flagvals,specs,specvals,varargin);
end

% Interpret input
directed = flagvals(1);

% Compute edges
if directed
    edges = compute_edges(obj,'directed');
else
    edges = compute_edges(obj,'undirected');
end

% Rows are values of edges, columns are placement of edges
incidence = sparse(edges(:),repmat(1:length(edges),1,2),ones(length(edges*2),1));

end

function [flagdef,specvals] = parse_function_input(flags,flagdef,specs,specdef,v)

flagvals = zeros(1,length(flags));
specvals = specdef;

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
            if any(strcmpi(v{i+1},specdef{foundloc}))
                specvals{foundloc} = [v{i+1},""];
                i = i + 2;
                continue
            else
                error('Specifier given with unknown value');
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