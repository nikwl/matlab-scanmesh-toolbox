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
% Copyright (c) 2018 Nikolas Lamb
%

% Compute adjacencies
adjacencies = adjacencyList(obj);

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

function [adjacencies] = adjacencyList(obj)
% Returns a cell array representing a list of all vertex connections in an

% Transpose and shift faces
facesT = obj.f';
facesSwT =[obj.f(:,2),obj.f(:,3),obj.f(:,1)]';

% Compute and sort facepairs
fpairs = [facesT(:),facesSwT(:)];
fpairsSorted = sortrows(fpairs);

% Preallocate adjacency list
for i = 1:max(fpairsSorted(:,1))
    adjacencies{i} = [];
end

% Initialize loop vairables
j = fpairsSorted(1,1);

% Initailize adjacency list
adjacencies{j}(end+1) = fpairsSorted(1,2);

% If an index is repeated, add to the current cell, else start a new cell
for i = 2:length(fpairsSorted)
    last = fpairsSorted(i-1,1);
    if last == fpairsSorted(i,1)
        adjacencies{j}(end+1) = fpairsSorted(i,2);
    else
        j = fpairsSorted(i,1);
        adjacencies{j}(end+1) = fpairsSorted(i,2);
    end
end

% Transpose adjacency list because it makes more sense that way
adjacencies = adjacencies';

end