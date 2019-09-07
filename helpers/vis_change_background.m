function [] = vis_change_background(color,fig)
% Changes the backround color of the figure to the specifed color and 
%   removes figure axis. Also ensures that saved figures will have the same 
%   background color. 
%
% Inputs:
%   color  - matrix, vector, or char defining the desired color. If vector 
%       must be 3 x 1. If char, must be color in matlab colorspec.
%   fig    - (optional) handle of figure to adjust 
%
% Copyright (c) 2019 Nikolas Lamb
%

% Set input figure as current
if ~exist('fig','var')
    fig = gcf;
end

if isempty(color)
    error('Color was of unknown type. Specify color as a matrx, vector or character.')
end

if ~isvector(color) && ~ischar(color) 
    error('Color was of unknown type. Specify color as a matrx, vector or character.') 
end

% Change background color
set(fig,'color',color);

% Ensure that saved figures are the same color
set(fig,'InvertHardCopy','off');

% Remove axis
axis off

end