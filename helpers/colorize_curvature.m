function [obj,angles] = colorize_curvature(obj,varargin)
% Colors the vertices of the object based on the local curvature by,
%   for each vertex v1, computing the average of angles between v1 + vn, 
%   v1, and all adjacent vertices.
%
% Inputs:
% 	obj     -  obj struct to colorize
%   optional args:
%      color_method  -  method of color binning:
%         1to1  -  generates |v| colors and assigns them in order of angle
%             magnitude. More visually distinct. (default)
%         binned  -  generates 100 colors, rescales angles between 1 and 
%             100, and bins angles based on their magnitude. More accurate
%             but due to gaussian distrubution is often difficult to see. 
% Outputs: 
%   obj     -  colorized obj struct
%   angles  -  |v| x 1 list of average angle at each vertex
%
% Local Dependancies:
%    compute_edges
%
% Copyright (c) 2019 Nikolas Lamb
%

% Define flags and specifiers
flags       = [];    
flagvals    = [];
specs       = ["color_method"];
specvals    = {["1to1" "binned"]};

% Parse input
if ~isempty(varargin)
    [flagvals,specvals] = parse_function_input(flags,flagvals,specs,specvals,varargin);
end

% Interpret input
colorize_method = specvals{1}(1);

% Make sure input object has correct face normals
if length(obj.vn) ~= length(obj.v)
    obj = perform_recompute_facenormals(obj);
end

% Get edges
edges = compute_edges(obj,'sorted');

% For each edge, compute angle between v1 + v1n, v1, and v2 
edge_angles = cellfun(@(x) angle_points(obj.v(x(1),:) + obj.vn(x(1),:),obj.v(x(1),:),obj.v(x(2),:)), num2cell(edges,2), 'UniformOutput', false);
edge_angles = cell2mat(edge_angles);

% Get the location of all angles for each vertex
num_verts = size(obj.v,1);
[~,starts] = unique(edges(:,1));
ends = [starts(2:end) - 1; size(edges,1)];
lens = ends - starts + 1;

% Sum angles for each vertex and devide by number of adjacencies
angles = zeros(num_verts,1);
for i = 1:num_verts
    angles(i) = sum(edge_angles(starts(i):ends(i))) ./ lens(i);
end

% Apply coloring
if strcmp(colorize_method,'1to1')
    [~,q] = sort(angles);
    obj.vc(q,:) = jet(num_verts);
elseif strcmp(colorize_method,'binned')
    num_bins = min(100,num_verts);
    binning = round(rescale(angles,1,num_bins));
    colors = jet(num_bins);
    obj.vc = colors(binning,:); 
end

end

function angle = angle_points(p1,p2,p3)

% Compute distances between each point
d12 = norm(p1-p2);
d23 = norm(p2-p3);
d31 = norm(p3-p1);

% Use law of cosines to compute angle
angle = real(acosd((d12.^2 + d23.^2 - d31.^2)/(2.*d12.*d23)));

end

function [flagdef,specvals] = parse_function_input(flags,flagdef,specs,specdef,v)

flagvals = zeros(1,length(flags));
specvals = specdef;

i = 1;
while i <= length(v)
    % Get the location of the flag or specifier in the provided list
    found = strcmpi(v{i},[flags,specs]);
    
    % Identifier not found
    if ~any(found)
        error('Unknown flag or specifier');
    end
    foundloc = find(found);
    
    % Identifier is a flag
    if foundloc <= length(flags)
        flagvals(foundloc) = 1;        
    else % Identifier is a specifier
        if i < length(v)
            if any(strcmpi(v{i+1},specdef{foundloc}))
                specvals{foundloc} = [v{i+1},""];
                i = i + 2;
                continue
            else
                error('Specifier given with unknown value');
            end
        else
            error('Specifier given with no value');
        end
    end
    i = i + 1;
end

% Conditionals

end