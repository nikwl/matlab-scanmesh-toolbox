function [fs,fidxs] = compute_find_faces(obj,vidxs)
% Finds every face in an object that references any of a list of vertices.
%    Returns the faces as a list of their vertex refernces. Optionally 
%    returns a list of indices to their position in obj.f.
%
% Inputs:
% 	 obj    -  object struct
% 	 vidxs  -  n x 1 list of vertex indices
% Outputs: 
%    fs     -  n x 3 list of faces that reference input vertices
%    fidxs  -  n x 1 list of face indices that reference input vertices
%      such that obj.f(fidxs(i),:) = fs(i,:)
%
% Copyright (c) 2018 Nikolas Lamb
%

% Find all elements of vidxs that appear in face list
c = ismember(obj.f,vidxs);

% Extract rows 
[fidxs,~] = find(c);
fidxs = unique(fidxs);

% Extract faces
fs = obj.f(fidxs,:);

end