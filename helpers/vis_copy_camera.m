function [cam_params] = vis_copy_camera()
% Returns an object containing several camera parameters that can be used
%   recreate the current view. Requires a figure to be open. 
%
% Outputs: 
%   cam_params  - object containing useful camera information
%
% Copyright (c) 2019 Nikolas Lamb
%

cam_params.camera_position = campos;
cam_params.camera_target = camtarget;
cam_params.x_limit = xlim;
cam_params.y_limit = ylim;
cam_params.z_limit = zlim;

end