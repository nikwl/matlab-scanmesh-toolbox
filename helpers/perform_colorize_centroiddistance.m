function [obj] = perform_colorize_centroiddistance(obj)
%  
%
% Inputs:
% 	obj  -  obj struct to visulize
%   optional args:
%      FaceColor  -  char, change color of object
%      EdgeColor  -  char, change color of object faces
%      Rescale    -  boolean, change the viewing window of active figure
%      Tag        -  char, add a custom tag to the generated patch
% Outputs: 
%   o    -  generated patch object
%   l    -  generated camlight
%
% Local Dependancies:
%    perform_delete_unreferenced_vertices
% 
% Example: 
%    obj = read_object('../test_files/duck.obj');
%    [o,l] = vis_object(obj,'FaceColor','c','EdgeColor','k');
%
% Copyright (c) 2018 Nikolas Lamb
%

centroid = sum(obj.v) ./ size(obj.v,1);




end