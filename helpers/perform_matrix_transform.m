function [obj,transM] = perform_matrix_transform(obj,trans)
% Applies a list of transformation matrices. Transformations are applied in
%   the order they are given. 
%
% Inputs:
%   obj     -  obj struct to transform 
%   trans   -  cell array of 4x4 transformation matrices
% Outputs: 
%   obj     -  transformed obj
%   transM  -  composed transformation matrix
% 
% Local Dependancies:
%   none
%
% Note: 
%
% Example: 
%

% How many transformations to apply
numtrans = length(trans);

% Multiply matricies if multiple transformations
if numtrans > 1
    transM = trans{1};
    for i = 2:numtrans
        transM = trans{i} * transM;
    end 
else
    transM = trans{1};
end

% Extract vertices, transpose, and homogenize 
vs = obj.v;
hvs = [vs,ones(length(vs),1)];
hvs = num2cell(hvs',1);

% Apply transformations in parallel
hvs = cellfun(@(x) transM*x,hvs,'UniformOutput',false);

% Convert back to array and transpose
hvs = cell2mat(hvs);
hvs = hvs';

% Return to obj struct
obj.v = hvs(:,1:3);

% Transform normals if they exist
if ~isempty(obj.vn)
    % Compute matrix inverse transpose to transform normals
    transMinv = inv(transM)';

    % Extract normals, transpose, and homogenize 
    vns = obj.vn;
    hvns = [vns,ones(length(vs),1)];
    hvns = num2cell(hvns',1);
    
    % Apply transformations in parallel
    hvns = cellfun(@(x) transMinv*x,hvns,'UniformOutput',false);
    
    % Convert back to array and transpose
    hvns = cell2mat(hvns);
    hvns = hvns';
    
    % Return to obj struct
    obj.vn = hvns(:,1:3);
end

end

