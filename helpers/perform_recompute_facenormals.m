function [obj] = perform_recompute_facenormals(obj)
% Recomputes object normal vectors by computing each vertex normal and
%   then averaging vertex normals for each face. Does not require vertex
%   normals or face normals to be populated.
%
% Inputs:
%    obj  -  obj struct
% Outputs: 
%	 obj  -  same obj struct now with fn and vn recomputed 
%
% Internal Functions:
%    normalFace
%    averageVectors
%    objFaceNormalsFromVertices
%
% Copyright (c) 2018 Nikolas Lamb
%

% Compute all face normals
fns = objFaceNormalsFromVertices(obj);

% Preallocate a list of vertex normals
vns = zeros(length(obj.v),3);

% Iterate over faces, adding face normals to each vertex reference
for i = 1:length(obj.f)
    vns(obj.f(i,1),:) = vns(obj.f(i,1),:) + fns(i,:);
    vns(obj.f(i,2),:) = vns(obj.f(i,2),:) + fns(i,:);
    vns(obj.f(i,3),:) = vns(obj.f(i,3),:) + fns(i,:);
end

% Normalize vectors
for i = 1:length(obj.v)
    vns(i,:) = vns(i,:)./norm(vns(i,:));
end

% Overwrite obj normals
obj.fn = obj.f;
obj.vn = vns;

end

function [ns] = objFaceNormalsFromVertices(obj)
% Computes the normal of each face by crossing the difference between two
%    vertices

% Extract vertices
vs1 = obj.v(obj.f(:,1),:);
vs2 = obj.v(obj.f(:,2),:);
vs3 = obj.v(obj.f(:,3),:);

% Interleave verticies to form shapes and convert into a cell array
expandFaces = reshape([vs1(:) vs2(:) vs3(:)]',3*size(obj.f,1), []);
expandFacesCell = mat2cell(expandFaces,ones(1,length(expandFaces)/3)*3, 3);

% Compute the normals of each cell
nsCell = cellfun(@normalFace,expandFacesCell,'UniformOutput',0);

% Convert into an array
ns = cell2mat(nsCell);

end

function [n] = averageVectors(vs)
% Returns the normalized sum of a list vectors.

% Compute the normalized sum of the input vectors
n = sum(vs);
n = n/norm(n);

end

function [n] = normalFace(sh)
% Returns the normal vector of the input shape

% Extract vertices
v1 = sh(1,:);
v2 = sh(2,:);
v3 = sh(3,:);

% Compute vector via cross product and normalize
n = cross(v1-v2,v2-v3);
n = n/norm(n);

end
