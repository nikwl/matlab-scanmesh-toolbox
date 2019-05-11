function [path,dist,steps] = astar(start,finish,vertices,adjacencies,path)
% Calculates the shortest distance between two points using the astar
%    shortest path algorithm. 
%
% Inputs:
% 	 start        -  index of starting vertex
% 	 finish       -  index of ending vertex
%    vertices     -  nx3 list of vertices
%    adjacencies  -  cell array adjacency list
%    path         -  (optional) initialize the path tracker
% Outputs: 
%    path         -  path from start to end
% 	 dist         -  edge-wise distance path traverses
%    steps        -  how many points were evaluated
%
% Note:
%    Use the optional path argument when calling the function repeatedly
%
%    In the case where no path is found, it will return the shortest path
% to every point in the mesh
%    
% Example: 
%    obj = read_object('../test_files/duck.obj');
%    adjacencies = compute_adjacencylist(obj);
%    [path,dist,steps] = astar(1,10,obj.v,adjacencies)
%
% Copyright (c) 2018 Nikolas Lamb
%

% Raise the cost function by this amount. Higher exponent = straighter path
exponenet = 1;

% If you'd like to watch the function run
vis = false;

% Determine number of vertices
[num_points,~] = size(vertices);

% If you didn't include a path initialization
if (nargin < 4)
    path = num2cell(NaN(num_points,1));
end

% Generate datastructures
dist_traversed_list = Inf(1,num_points);
dist_to_goal_list = Inf(1,num_points);
closed_list = sparse(1,num_points);
open_list = sparse(1,num_points);

% Initialize datastructues
open_list(start) = 1;
path(start) = {start};
dist_traversed_list(start) = 0;
valid_pts = find(open_list);
dist = 0;

% Shows start and end vertex in blue
if vis
    figure
    hold on
    vstart = vertices(start,:);
    vfinish = vertices(finish,:);
    scatter3(vstart(1),vstart(2),vstart(3),'b');
    scatter3(vfinish(1),vfinish(2),vfinish(3),'b');
    prevstart = [];
end

% Counts how many points were evaluated
steps = 0;

% Run astar
while ~isempty(valid_pts) 
    % Find point in open_list closest to goal
    valid_pts = find(open_list);
    dist_to_goal_list(valid_pts);
    [~,minimum_index] = min(dist_to_goal_list(valid_pts));
    
    % Pop parent from open_list
    parent = valid_pts(minimum_index);
    open_list(parent) = 0;

    % Get children of closest point 
    children = adjacencies{parent};
    
    for child = children
        % Distance from parent to child
        dist_edge = distance(vertices(parent,:),vertices(child,:));
        
        % Distance to finish
        dist_goal = distance(vertices(finish,:),vertices(child,:));      
        
        % Determine child's heuristic value
        dist_child = dist_goal .^ exponenet + dist_traversed_list(parent) + dist_edge;
        
        if (child == finish) % Found it
            % Update distances to child
            dist_traversed_list(child) = dist_traversed_list(parent) + dist_edge;
            
            % Update path
            tmp_path = path(parent);
            path(child) = {[tmp_path{1} child]};
            
            % Extract distance to be reutrned
            dist = dist_traversed_list(child);

            % Extract path to be returned
            path = path(finish);
            path = path{1};
            
            % Visulize last point, if desired
            if vis
                anim(vstart,child,parent,vertices); 
                scatter3(vfinish(1),vfinish(2),vfinish(3),'b');
            end
            
            % You've completed another iteration
            steps = steps + 1;
            
            return; 
        elseif (open_list(child) == 1) && (dist_to_goal_list(child) < dist_child)
            continue;
        elseif (closed_list(child) == 1) && (dist_to_goal_list(child) < dist_child)
            continue;
        else
            % Update distances to child
            dist_traversed_list(child) = dist_traversed_list(parent) + dist_edge;
            dist_to_goal_list(child) = dist_child;
            
            % Update path
            tmp_path = path(parent);
            path(child) = {[tmp_path{1} child]};
            
            % Add to open list
            open_list(child) = 1;
            
            % Visulize current point, if desired
            if vis, delete(prevstart); prevstart = anim(vstart,child,parent,vertices); end
        end
     end
    % Add parent to closed_list
    closed_list(parent) = 1; 
    
    % You've completed another iteration
    steps = steps + 1;
end

% You've run out of points and I haven't found a path
warning('No path found\n');

end

% Very small function to compute distance
function [dist] = distance(start,finish)
    dist = sqrt(sum((start - finish).^2));
end

% Small function to take care of animating progress
function [prevstart] = anim(vstart,child,parent,vertices)
    vchild = vertices(child,:);
    vparent = vertices(parent,:);
    
    % Connections are shown in green
    plot3([vchild(1),vparent(1)],[vchild(2),vparent(2)],[vchild(3),vparent(3)],'g');
    
    % Vertices are shown in red
    scatter3(vchild(1),vchild(2),vchild(3),'r');
    
    % Redraw start vertex
    prevstart = scatter3(vstart(1),vstart(2),vstart(3),'b');
    drawnow
end