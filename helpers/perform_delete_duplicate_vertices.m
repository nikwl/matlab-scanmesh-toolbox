function [obj] = perform_delete_duplicate_vertices(obj)
% Returns an object with duplicate vertices deleted. Faces are remapped to
%    maintain object structure. Requires helper function 
%    perform_delete_vertices
%
% Inputs:
% 	 obj  -  object struct
% Outputs: 
% 	 obj  -  object struct with duplicate vertices removed
%
% Copyright (c) 2018 Nikolas Lamb
%

% Find unique vertices
[~,ci,~] = unique(obj.v,'rows');

% Find repeated vertices
vremove = setdiff([1:length(obj.v)],ci);

% Delete repaeted vertices 
obj = perform_delete_vertices(obj,vremove);

end