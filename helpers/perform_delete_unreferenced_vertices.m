function [obj] = perform_delete_unreferenced_vertices(obj)
% Returns the input object with any unrefernced vertices deleted. Faces are
%    remapped to maintain object structure.
%
% Inputs:
% 	 obj    -  obj struct
% Outputs: 
% 	 obj    -  obj struct with unreferenced vertices removed
%
% Local Dependancies
%    perform_delete_vertices
%
% Copyright (c) 2018 Nikolas Lamb
%

% Compute an index list of all vertices
allvs = 1:length(obj.v);

% Compute an index list of all referenced vertices
refvs = unique(obj.f(:))';

% Compute the difference, that is unreferenced vertices
unrefvs = setdiff(allvs',refvs');

% Delete these vertices
obj = perform_delete_vertices(obj,unrefvs);

end