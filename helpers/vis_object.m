function [] = vis_object(obj)
% Visulizes an object in cyan using matlab's patch function. Does not apply
%    texture information. 
%
% Inputs:
% 	obj  -  obj struct to visulize
%
% Copyright (c) 2018 Nikolas Lamb
%

% Define viewer
axis equal
hold on
xlim([min(obj.v(:,1)),max(obj.v(:,1))]);
ylim([min(obj.v(:,2)),max(obj.v(:,2))]);
zlim([min(obj.v(:,3)),max(obj.v(:,3))]);
view([max(obj.v(:,1)),max(obj.v(:,2)),max(obj.v(:,3))]);

% Use patch to display obj
patch('Vertices',obj.v,'Faces',obj.f,'EdgeColor','k','FaceColor','c')
drawnow

end