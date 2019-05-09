function [edges] = compute_edges(obj,varargin)
% Returns a list of all edges in the object. 
%
% Inputs:
% 	obj    -  object struct
%   optional args:
%      stable      -  returns edges such that the i'th edge belongs to the
%        ceil(i/3)th face (default)
%      sorted      -  returns edges sorted by occurance in vertex list
%      directed    -  assumes directed mesh (default)
%      undirected  -  assumes undirected mesh
% Outputs: 
% 	 edges  -  |e| x 2 list of edges
%
% Copyright (c) 2018 Nikolas Lamb
%

% Define flags and specifiers
flags       = ["stable" "sorted" "directed" "undirected"];    
flagvals    = [1 0 1 0];
specs       = [];
specvals    = [];

% Parse input
if length(varargin) ~= 0
    [flagvals,specvals] = parse_function_input(flags,flagvals,specs,specvals,varargin);
end

% Directed
if flagvals(3)
    facesT = obj.f';
    facesSwT =[obj.f(:,2),obj.f(:,3),obj.f(:,1)]';
    edges = [facesT(:),facesSwT(:)];
    
    % Sort
    if flagvals(2)
        edges = sortrows(edges);
    end
else % Undirected 
    facesT = obj.f';
    facesSwT =[obj.f(:,2),obj.f(:,3),obj.f(:,1)]';
    edges = [facesT(:),facesSwT(:);facesSwT(:),facesT(:)];
    edges = unique(edges,'rows');
end

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
        error('Cant be both stable and sorted');
    end
    flagdef(1) = flagvals(1);
    flagdef(2) = flagvals(2);
end
  
if flagvals(3) || flagvals(4) 
    if flagvals(3) && flagvals(4) 
        error('Cant be both directed and undirected');
    end
    flagdef(3) = flagvals(3);
    flagdef(4) = flagvals(4);
end

if flagvals(4) || flagvals(1)
    if flagvals(1) && flagvals(4)
        error('Cant be both stable and undirected');
    elseif flagvals(1)
        flagdef(3) = 1;
        flagdef(4) = 0;
    elseif flagvals(4)
        flagdef(1) = 0;
        flagdef(2) = 1;
    end
end

end