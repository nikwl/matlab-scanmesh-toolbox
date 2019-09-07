function [] = vis_fill_camera(fig)
% Roughly equalizes the viewing space of the current figure so that it 
%   mimics the aspect ratio of the figure window. 
%
% Inputs:
%   fig  - (optional) handle of figure to adjust 
%
% Copyright (c) 2019 Nikolas Lamb
%

% Set input figure as current
if exist('fig','var')
    set(0, 'CurrentFigure', fig);
else
    fig = gcf;
end

% Get the resolution of the figure window
pos = get(fig, 'Position');

% Height to width ratio
r = pos(3) ./ pos(4);

% Get height of z axis
z_limit = zlim;
z_height = z_limit(2) - z_limit(1);

% Get center of x and y axis
x_limit = xlim;
y_limit = ylim;
x_center = x_limit(2) - ((x_limit(2) - x_limit(1)) ./ 2);
y_center = y_limit(2) - ((y_limit(2) - y_limit(1)) ./ 2);

% Compute new width based on ratio
new_width = (z_height * r) ./ 2;

% Set new width
xlim([x_center - new_width, x_center + new_width]);
ylim([y_center - new_width, y_center + new_width]);

end