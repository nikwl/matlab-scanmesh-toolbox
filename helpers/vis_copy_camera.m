function [cam_params] = vis_copy_camera(fig)
% Returns an object containing several camera parameters that can be used
%   recreate the current view. Requires a figure to be open. 
%
% Outputs: 
%   cam_params  - object containing useful camera information
%   fig         - (optional) handle of figure to adjust 
%
% Copyright (c) 2019 Nikolas Lamb
%

% Set input figure as current
if exist('fig','var')
    set(0, 'CurrentFigure', fig);
else
    set(0, 'CurrentFigure', gcf);
end

cam_params.camera_position = campos;
cam_params.camera_target = camtarget;
cam_params.x_limit = xlim;
cam_params.y_limit = ylim;
cam_params.z_limit = zlim;

end