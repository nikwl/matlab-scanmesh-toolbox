function [obj] = perform_delete_vertices(obj,vidxs)
% Returns the object with the specified vertices deleted. Faces are 
%    remapped to maintain object structure. Input vertices as a list of
%    indices in obj.v to delete.
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
allPts = [1:length(obj.v)]';
allPts(vidxs) = -1;

% Initialize list of valid point indices
newPts = [];

% Initialize deletion incrementor
delcount = 0;

% Note number of invalid points above each point and flag valid points
for i = 1:length(allPts)
    if allPts(i,1) == -1
        delcount = delcount + 1;
    else 
        newPts(end+1,1) = allPts(i,1);
    end
    allPts(i,2) = delcount;
end

% Determine modified index of valid points
allPts(:,3) = allPts(:,1) - allPts(:,2);

% Make invalid face references negative
obj.f(:,1) = allPts(obj.f(:,1),3);
obj.f(:,2) = allPts(obj.f(:,2),3);
obj.f(:,3) = allPts(obj.f(:,3),3);

% Find invalid references
[r,~] = find(obj.f<1);

% Remap face and face normal lists
obj.f(r,:) = [];
obj.ft(r,:) = [];
obj.fn(r,:) = [];

% Remap vertex and vertex normal lists
obj.v = obj.v(newPts,:);
if ~isempty(obj.vc); obj.vc = obj.vc(newPts,:); end;
if ~isempty(obj.vn); obj.vn = obj.vn(newPts,:); end;


end