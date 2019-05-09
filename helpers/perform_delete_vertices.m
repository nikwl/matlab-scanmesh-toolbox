function [obj] = perform_delete_vertices(obj,vidxs)
% Returns the object with the specified vertices deleted. Faces are 
%    remapped to maintain object structure. Input vertices as a list of
%    indices in obj.v to delete.
%
% Inputs:
% 	 obj    -  object struct
% 	 vidxs  -  n x 1 list of vertex indices
% Outputs: 
% 	 obj    -  object struct with specified vertices removed
%
% Copyright (c) 2018 Nikolas Lamb
%

% Make sure there are actually vertices to delete
if isempty(vidxs)
   return 
end

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

% Extract length of old face list
flen = length(obj.f);

% Delete faces that referenced remove vertices
obj.f(r,:) = [];

% Avoids indexing errors when |fn| < |f|
fnlen = length(obj.fn);
if flen ~= fnlen
    rnew = r(r < flen);
    obj.fn(rnew,:) = [];
    
    % |fn| shouldnt be > |f|
    if fnlen > flen
        obj.fn(flen:end) = [];
    end
end

% Extract length of old vertex list
vlen = length(obj.v);

% Remap vertices
obj.v = obj.v(newPts,:);

% Avoids indexing errors when |vc| < |v|
vclen = length(obj.vc);
if vlen ~= vclen
    vcNewPts = newPts(newPts < vclen);
    obj.vc = obj.vc(vcNewPts,:);
else
    obj.vc = obj.vc(newPts,:);
end

% Avoids indexing errors when |vn| < |f|
vnlen = length(obj.vn);
if vlen ~= vnlen    
    vnNewPts = newPts(newPts < vnlen);
    obj.vn = obj.vn(vnNewPts,:);
else
    obj.vn = obj.vn(newPts,:);
end

end