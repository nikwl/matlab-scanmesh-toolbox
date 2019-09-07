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
%      undirected  -  assumes undirected mesh, ie symmetric edges
% Outputs: 
% 	 edges  -  |e| x 2 list of edges
%
% Copyright (c) 2018 Nikolas Lamb
%

% Define flags and specifiers
flags       = ["stable" "sorted" "directed" "undirected"];    
flagvals    = [1 0 1 0];
specs       = [];
specvals    = {[]};

% Parse input
if ~isempty(varargin)
    [flagvals,specvals] = parse_function_input(flags,flagvals,specs,specvals,varargin);
end

% Interpret input
directed = flagvals(3);
sorted = flagvals(2);

% Directed
if directed
    facesT = obj.f';
    facesSwT =[obj.f(:,2),obj.f(:,3),obj.f(:,1)]';
    edges = [facesT(:),facesSwT(:)];
    
    % Sort
    if sorted
        edges = sortrows(edges);
    end
else % Undirected 
    facesT = obj.f';
    facesSwT =[obj.f(:,2),obj.f(:,3),obj.f(:,1)]';
    edges = [facesT(:),facesSwT(:);facesSwT(:),facesT(:)];
    edges = unique(edges,'rows');
end

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