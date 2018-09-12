function [divisions] = compute_segmentation(obj)
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
% Copyright (c) 2018 Nikolas Lamb
%

% Compute adjacencies
adjacencies = compute_adjacencylist(obj);

% List all points that are connected
connectedPoints = horzcat(adjacencies{:});

% Initialize loop variables
seeds = connectedPoints;
i = 1;
divisions{i} = [];
excl = [];
inclall = [];

% Loop conditionals
a = true;
b = true;

% Segment the object
while b
    % Initialize loop variables
    temp = setdiff(seeds,[excl,inclall']);
    next = temp(1);
    incl = next;
   
    % Segment the object, using next like a wave bounded by excl
    while a
        next = horzcat(adjacencies{next})';
        next = setdiff(next,[excl,incl']);
        incl = [incl;next];
        if isempty(next)
            a = false;
        end 
    end
    
    % Add inclusions to the count
    divisions{i} = incl;
    inclall = [inclall;incl];
    
    % Check if there are no more possible
    seeds = setdiff(connectedPoints,[excl,inclall']);
    
    % Break if there are none else create a new division
    if isempty(seeds)
        b = false;
    else
        a = true;
        i = i + 1;
    end
end

end
