function [obj] = perform_facenormal_recompute(obj)
% Recomputes object normal vectors by computing each vertex normal and
%   then averaging vertex normals for each face. Does not require vertex
%   normals or face normals to be populated.
%
% Inputs:
%    obj  -  obj struct
% Outputs: 
%	 obj  -  same obj struct now with fn and vn recomputed 
%
% Copyright (c) 2018 Nikolas Lamb
%

% Compute all face normals
ns = objFaceNormalsFromVertices(obj);

% Initialize the vertex relations list
for i = 1:length(obj.v)
    vertexRelations{i} = []; 
end

% Compute the index of every face each vertex is found on
for i = 1:length(obj.f)
    vertexRelations{obj.f(i,1)} = [vertexRelations{obj.f(i,1)},i]; 
    vertexRelations{obj.f(i,2)} = [vertexRelations{obj.f(i,2)},i]; 
    vertexRelations{obj.f(i,3)} = [vertexRelations{obj.f(i,3)},i]; 
end

% Transpose the list 
vertexRelations = vertexRelations';

% Extract the normals from the list for each face for each vertex
for i = 1:length(obj.v)
    vertexRelatedNormals{i} = ns(vertexRelations{i},:);
end

% Transpose the list 
vertexRelatedNormals = vertexRelatedNormals';

% Compute the average of the normals of the found faces for each vertex
vertexNormals = cellfun(@averageVectors,vertexRelatedNormals,'UniformOutput',false);

% cell2mat done via loop because matlab is literally the worst
for i = 1:length(vertexNormals)
    vs(i,:) = vertexNormals{i};
end

% Overwrite obj normals
obj.vn = vs;
obj.fn = obj.f;

end

function [n] = averageVectors(vs)
% Returns the normalized sum of a list vectors.

% Compute the normalized sum of the input vectors
n = sum(vs);
n = n/norm(n);

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
