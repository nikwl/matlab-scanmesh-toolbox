function [] = vis_paste_camera(cam_params,fig)
% Applies camera_params object created by vis_copy_camera to the current
%    figure. Requires a figure to be open. 
%
% Inputs:
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

campos(cam_params.camera_position);
camtarget(cam_params.camera_target);
xlim(cam_params.x_limit);
ylim(cam_params.y_limit);
zlim(cam_params.z_limit);

end