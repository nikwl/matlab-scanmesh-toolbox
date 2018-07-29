function [] = vis_object_segment(obj,fs)
% Visulizes a portion of an object in red, the rest in cyan, using matlab's 
%    patch function. Does not apply texture information. Useful for
%    identifying regions of an object visually. 
% 
% Inputs:
%    obj  -  obj struct corresponding to input faces
% 	 fs   -  nx1 list of faces to visulize
%
% Copyright (c) 2018 Nikolas Lamb
%

% If faces is empty, just show the object
if isempty(fs)
    axis equal
    patch('Vertices',obj.v,'Faces',obj.f,'EdgeColor','k','FaceColor','c')
    drawnow
else 
    % Extract cnfaces
    cnfaces = obj.f(faces,:);
    
    % Define viewer
    axis equal
    hold on
    xlim([min(obj.v(:,1)),max(obj.v(:,1))]);
    ylim([min(obj.v(:,2)),max(obj.v(:,2))]);
    zlim([min(obj.v(:,3)),max(obj.v(:,3))]);
    view([max(obj.v(:,1)),max(obj.v(:,2)),max(obj.v(:,3))]);
    
    % Use patch to display obj with color corlation
    patch('Vertices',obj.v,'Faces',faces,'EdgeColor','k','FaceColor','r')
    patch('Vertices',obj.v,'Faces',cnfaces,'EdgeColor','k','FaceColor','c')
    drawnow
end

end