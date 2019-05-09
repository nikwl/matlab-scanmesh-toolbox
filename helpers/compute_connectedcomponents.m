function [components] = compute_connectedcomponents(obj)
% Segments object into groups of points. The number of elements in the
%    returned cell array will determine number of independant components in
%    obj. Useful in tandem with perform_delete_vertices to remove artifacts  
%    that you can't easily see in a wysiwyg editor. 
%
% Inputs:
% 	obj        -  object struct
% Outputs: 
%   divisions  -  |cc| x n cell array of segments containing point indices
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
covered = [];
i = 1;

% Segment the object
while true
    % Initialize loop variables
    temp = setdiff(seeds,covered');
    next = temp(1);
    include = next;
   
    % Segment the object, using next like a wave bounded by excl
    while true
        next = horzcat(adjacencies{next})';
        next = setdiff(next,[include']);
        include = [include;next];
        if isempty(next)
            break;
        end 
    end
    
    % Add inclusions to the count
    components{i} = include;
    covered = [covered;include];
    
    % Check if there are no more possible
    seeds = setdiff(connectedPoints,covered');
    
    % Break if there are none else create a new division
    if isempty(seeds)
        break;
    else
        i = i + 1;
    end
end

end
