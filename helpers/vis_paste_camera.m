function [] = vis_paste_camera(cam_params)
% Applies camera_params object created by vis_copy_camera to the current
%    figure. Requires a figure to be open. 
%
% Outputs: 
%   cam_params  - object containing useful camera information
%
% Copyright (c) 2019 Nikolas Lamb
%

campos(cam_params.camera_position);
camtarget(cam_params.camera_target);
xlim(cam_params.x_limit);
ylim(cam_params.y_limit);
zlim(cam_params.z_limit);

end