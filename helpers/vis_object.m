function [o,l] = vis_object(obj,varargin)
% Visulizes an object in cyan using matlab's patch function. Does not 
%    apply texture information. Useful for visual object analysis. 
%
% Inputs:
% 	obj  -  obj struct to visulize
%   optional args:
%      Color    -  char, change color of object
%      Rescale  -  boolean, change the viewing window of active figure
%      Tag      -  char, add a custom tag to the generated patch
% Outputs: 
%   o    -  generated patch object
%   l    -  generated camlight
%
% Local Dependancies:
%   none
%
% Note: 
%
% Example: 
%
% Copyright (c) 2018 Nikolas Lamb
%

% Assign and parse additional inputs
p = inputParser;
defaultColor = 'c';
defaultRescale = true;
defaultTag = '1a';

addRequired(p,'obj',@isstruct);
addParameter(p,'Color',defaultColor,@ischar);
addParameter(p,'Rescale',defaultRescale);
addParameter(p,'Tag',defaultTag);

parse(p,obj,varargin{:});

% Reassign variable names
obj = p.Results.obj;
color = p.Results.Color;
rescale = p.Results.Rescale;
tag = p.Results.Tag;

% Define viewer
axis equal
hold on
if rescale
    xlim([min(obj.v(:,1)),max(obj.v(:,1))]);
    ylim([min(obj.v(:,2)),max(obj.v(:,2))]);
    zlim([min(obj.v(:,3)),max(obj.v(:,3))]);
    view([max(obj.v(:,1)),max(obj.v(:,2)),max(obj.v(:,3))]);
end

% Use patch to display obj
o = patch('Vertices',obj.v,'Faces',obj.f,'EdgeColor','n','FaceColor',color,'Tag',tag);
l = camlight;

drawnow

end