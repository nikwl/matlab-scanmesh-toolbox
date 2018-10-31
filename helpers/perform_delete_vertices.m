function [obj] = perform_delete_vertices(obj,vidxs)
% Returns the object with the specified vertices deleted. Faces are 
%    remapped to maintain object structure. Input vertices as a list of
%    indices in obj.v to delete. Will delete vc and vn if they are
%    present. Will not delete vt.
%
% Inputs:
% 	 obj    -  object struct
% 	 vidxs  -  nx1 list of vertex indices
% Outputs: 
% 	 obj    -  object struct with specified vertices removed
%
% Copyright (c) 2018 Nikolas Lamb
%

% Generate list of all point indices, flag points to remove
allpoints = [1:length(obj.v)]';
allpoints(vidxs) = -1;

% Initialize list of valid point indices
newpoints = [];

% Initialize deletion incrementor
deletecount = 0;

% Note number of invalid points above each point and flag valid points
for i = 1:length(allpoints)
    if allpoints(i,1) == -1
        deletecount = deletecount + 1;
    else
        newpoints(end+1,1) = allpoints(i,1);
    end
    allpoints(i,2) = deletecount;
end

% Determine modified index of valid points
allpoints(:,3) = allpoints(:,1) - allpoints(:,2);

% Make invalid face references negative
obj.f(:,1) = allpoints(obj.f(:,1),3);
obj.f(:,2) = allpoints(obj.f(:,2),3);
obj.f(:,3) = allpoints(obj.f(:,3),3);

% Find invalid references
[faces,~] = find(obj.f<1);

% Remap face and face normal lists
obj.f(faces,:) = [];
if ~isempty(obj.ft); obj.ft(faces,:) = []; end
if ~isempty(obj.fn); obj.fn(faces,:) = []; end

% Remap vertex and vertex normal lists
obj.v = obj.v(newpoints,:);
if ~isempty(obj.vc); obj.vc = obj.vc(newpoints,:); end
if ~isempty(obj.vn); obj.vn = obj.vn(newpoints,:); end

end