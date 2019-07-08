function [obj] = colorize_centroiddistance(obj,varargin)
% Colors the vertices of the object based on how far away they are from the
%   object's centroid. 
%
% Inputs:
% 	obj  -  obj struct to colorize
%   optional args:
%      color_method  -  method of color binning:
%         1to1  -  generates |v| colors and assigns them in order of angle
%             magnitude. More visually distinct. (default)
%         binned  -  generates 100 colors, rescales angles between 1 and 
%             100, and bins angles based on their magnitude. More accurate
%             but due to gaussian distrubution is often difficult to see. 
% Outputs: 
%   obj  -  colorized obj struct
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

% Compute object centroid
num_verts = size(obj.v,1);
centroid = sum(obj.v) ./ num_verts;

% Get distance as norm of difference between each vertex and the centroid
dist = cellfun(@norm, num2cell(obj.v - repmat(centroid,[num_verts,1]), 2));

% Apply coloring
if strcmp(colorize_method,'1to1')
    [~,q] = sort(dist);
    obj.vc(q,:) = jet(num_verts);
elseif strcmp(colorize_method,'binned')
    num_bins = min(100,num_verts);
    binning = round(rescale(dist,1,num_bins));
    colors = jet(num_bins);
    obj.vc = colors(binning,:); 
end

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