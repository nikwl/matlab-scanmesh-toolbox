function [fig,o,so,l] = vis_object_segment(obj,poi,select,varargin)
% Visulizes a portion of an object in red, the rest in cyan, using matlab's 
%    patch function. Does not apply texture information. Useful for
%    identifying regions of an object visually. 
% 
% Inputs:
% 	obj    - obj struct to visulize
%   faces  - nx1 list of faces to highlight
%   optional args:
%      Color     - char, change color of object 
%      SegColor  - char, change color of object segment
%      Rescale   - boolean, change the viewing window of active figure
%      Tag       - char, add a custom tag to the generated patch
%      SegTag    - char, add a custom tag to the generated seg patch
% Outputs: 
%   o      - generated patch object
%   so     - generated patch object segment
%   l      - generated camlight
%
% Local Dependancies:
%   vis_object
%   perform_delete_unreferenced_vertices
%
% Note: 
%
% Example: 
%
% Copyright (c) 2019 Nikolas Lamb
%

% Assign and parse additional inputs
p = inputParser;
defaultFaceColor = 'c';
defaultSegFaceColor = 'r';
defaultEdgeColor = 'n';
defaultSegEdgeColor = 'n';
defaultRescale = true;
defaultTag = '1a';
defaultSegTag = '1b';
defaultFig = gcf;

if ~exist('select','var')
   select = 'Faces';
elseif ~any(strcmp({'Faces','Vertices'},select))
   error('Unknown input for select. Choices: Faces, Vertices');
end

if strcmp(select,'Faces')
    defaultSegEdgeColor = 'n';
elseif strcmp(select,'Vertices')
    defaultSegEdgeColor = 'k';
end

addRequired(p,'obj',@isstruct);
addRequired(p,'poi',@isvector);
addRequired(p,'select',@isstr);
addParameter(p,'FaceColor',defaultFaceColor,@ischar);
addParameter(p,'SegFaceColor',defaultSegFaceColor,@ischar);
addParameter(p,'EdgeColor',defaultEdgeColor,@ischar);
addParameter(p,'SegEdgeColor',defaultSegEdgeColor,@ischar);
addParameter(p,'Rescale',defaultRescale);
addParameter(p,'Tag',defaultTag);
addParameter(p,'SegTag',defaultSegTag);
addParameter(p,'Fig',defaultFig);

parse(p,obj,poi,select,varargin{:});

% Reassign variable names
obj = p.Results.obj;
poi = p.Results.poi;
select = p.Results.select;
facecolor = p.Results.FaceColor;
segfacecolor = p.Results.SegFaceColor;
edgecolor = p.Results.EdgeColor;
segedgecolor = p.Results.SegEdgeColor;
rescale = p.Results.Rescale;
tag = p.Results.Tag;
segtag = p.Results.SegTag;
fig = p.Results.Fig;

if strcmp(select,'Faces')
    % Extract faces
    sobj = obj;
    sobj.f = obj.f(poi,:);
    sobj = perform_delete_unreferenced_vertices(sobj);
    obj.f = setdiff(obj.f,sobj.f,'rows');

    % Use patch to display obj with color corlation
    [fig,o,l] = vis_object(obj,'FaceColor',facecolor,'EdgeColor',edgecolor,'Rescale',rescale,'Tag',tag,'Fig',fig);
    delete(l);
    [so,l] = vis_object(sobj,'FaceColor',segfacecolor,'EdgeColor',segedgecolor,'Rescale',false,'Tag',segtag,'Fig',fig);
    drawnow
elseif strcmp(select,'Vertices')
    verts = obj.v(poi,:);
    % Use patch to display obj with color corlation
    [fig,o,l] = vis_object(obj,'FaceColor',facecolor,'EdgeColor',edgecolor,'Rescale',rescale,'Tag',tag,'Fig',fig);
    hold on
    so = scatter3(verts(:,1),verts(:,2),verts(:,3),100,segfacecolor,'filled','MarkerEdgeColor',segedgecolor,'Tag',segtag);
end

end