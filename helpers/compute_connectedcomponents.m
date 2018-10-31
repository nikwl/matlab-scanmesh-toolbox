function [components] = compute_connectedcomponents(obj)
% Segments object into groups of points. The number of elements in the
%    returned cell array will determine number of independant segments in
%    obj. Useful in tandem with perform_delete_vertices to remove artifacts  
%    that you can't easily see in a wysiwyg editor. 
%
% Inputs:
% 	obj        -  object struct
% Outputs: 
%   divisions  -  mxn cell array of segments containing point indices
%
% Local Dependancies:
%   compute_adjacencylist
%
% Notes: 
%   Based on Tarjan's strongly connected components algorithm, except this
%   implementation uses BFS instead of DFS.
%
% Copyright (c) 2018 Nikolas Lamb
%

% Compute adjacencies
adjacencies = compute_adjacencylist(obj);

% List all points that are connected
connectedPoints = horzcat(adjacencies{:});

% Initialize loop variables
seeds = connectedPoints;
i = 1;
components{1} = [];
exclude = [];
includeall = [];

% Loop conditionals
a = true;
b = true;

% Segment the object
while b
    % Initialize loop variables
    temp = setdiff(seeds,[exclude,includeall']);
    next = temp(1);
    incl = next;
   
    % Segment the object, using next like a wave bounded by excl
    while a
        next = horzcat(adjacencies{next})';
        next = setdiff(next,[exclude,incl']);
        incl = [incl;next];
        if isempty(next)
            a = false;
        end 
    end
    
    % Add inclusions to the count
    components{i} = incl;
    includeall = [includeall;incl];
    
    % Check if there are no more possible
    seeds = setdiff(connectedPoints,[exclude,includeall']);
    
    % Break if there are none else create a new division
    if isempty(seeds)
        b = false;
    else
        a = true;
        i = i + 1;
    end
end

end
