function [o,so,l] = vis_object_segment(obj,faces,varargin)
% Visulizes a portion of an object in red, the rest in cyan, using matlab's 
%    patch function. Does not apply texture information. Useful for
%    identifying regions of an object visually. 
% 
% Inputs:
% 	obj    -  obj struct to visulize
%   faces  -  nx1 list of faces to highlight
%   optional args:
%      Color     -  char, change color of object 
%      SegColor  -  char, change color of object segment
%      Rescale   -  boolean, change the viewing window of active figure
%      Tag       -  char, add a custom tag to the generated patch
%      SegTag    -  char, add a custom tag to the generated seg patch
% Outputs: 
%   o      -  generated patch object
%   so     -  generated patch object segment
%   l      -  generated camlight
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
defaultSegColor = 'r';
defaultRescale = true;
defaultTag = '1a';
defaultSegTag = '1b';

addRequired(p,'obj',@isstruct);
addRequired(p,'faces',@isvector);
addParameter(p,'Color',defaultColor,@ischar);
addParameter(p,'SegmentColor',defaultSegColor,@ischar);
addParameter(p,'Rescale',defaultRescale);
addParameter(p,'Tag',defaultTag);
addParameter(p,'SegTag',defaultSegTag);

parse(p,obj,faces,varargin{:});

% Reassign variable names
obj = p.Results.obj;
faces = p.Results.faces;
color = p.Results.Color;
segcolor = p.Results.SegmentColor;
rescale = p.Results.Rescale;
tag = p.Results.Tag;
segtag = p.Results.SegTag;

% Define viewer
axis equal
hold on
if rescale
    xlim([min(obj.v(:,1)),max(obj.v(:,1))]);
    ylim([min(obj.v(:,2)),max(obj.v(:,2))]);
    zlim([min(obj.v(:,3)),max(obj.v(:,3))]);
    view([max(obj.v(:,1)),max(obj.v(:,2)),max(obj.v(:,3))]);
end

% Extract cnfaces
cnfaces = obj.f(faces,:);

% Use patch to display obj with color corlation
o = patch('Vertices',obj.v,'Faces',obj.f,'EdgeColor','n','FaceColor',color,'Tag',tag);
so = patch('Vertices',obj.v,'Faces',cnfaces,'EdgeColor','n','FaceColor',segcolor,'Tag',segtag);
l = camlight;
drawnow

end