function [fig,o,l] = vis_object(obj,varargin)
% Visulizes an object in cyan using matlab's patch function. Does not 
%    apply texture information. Useful for visual object analysis. 
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

% Assign and parse additional inputs
p = inputParser;
defaultFColor = [];
defaultEcolor = 'n';
defaultRescale = true;
defaultTag = '1a';
defaultFig = gcf;

addRequired(p,'obj',@isstruct);
addParameter(p,'FaceColor',defaultFColor,@ischar);
addParameter(p,'EdgeColor',defaultEcolor,@ischar);
addParameter(p,'Rescale',defaultRescale);
addParameter(p,'Tag',defaultTag);
addParameter(p,'Fig',defaultFig);

parse(p,obj,varargin{:});

% Reassign variable names
obj = p.Results.obj;
fcolor = p.Results.FaceColor;
ecolor = p.Results.EdgeColor;
rescale = p.Results.Rescale;
tag = p.Results.Tag;
fig = p.Results.Fig;

% Set fig as current
set(0, 'CurrentFigure', fig)

% Empty pass trackers
coloremp = false;

% Update empty pass trackers
if isempty(fcolor)
    fcolor = 'c';
    coloremp = true;
end

% Remove any unreferenced vertices if present (this messes with patch)
if length(obj.v) ~= length(obj.vc)
    obj = perform_delete_unreferenced_vertices(obj);
end

% Define viewer
axis equal
if rescale
    % Find max and min referenced vertices
    mini = min(obj.v(horzcat(obj.f),:));
    maxi = max(obj.v(horzcat(obj.f),:));
    axis equal
    xlim([mini(1),maxi(1)]);
    ylim([mini(2),maxi(2)]);
    zlim([mini(3),maxi(3)]);
    view([maxi(1),maxi(2),maxi(3)]);
end

% Use patch to display obj
if (~isempty(obj.vc) && coloremp)
    o = patch('Vertices',obj.v,'Faces',obj.f,'EdgeColor',ecolor,'FaceVertexCData',obj.vc,'Tag',tag);
    o.FaceColor = 'interp';
    material([.6,.5,0])
    l = camlight;
else
    o = patch('Vertices',obj.v,'Faces',obj.f,'EdgeColor',ecolor,'FaceColor',fcolor,'Tag',tag);
    material([.6,.5,0])
    l = camlight;
end

drawnow

end