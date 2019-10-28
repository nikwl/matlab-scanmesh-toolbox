function [obj] = lsmoothing(obj)

edges = compute_edges(obj,'undirected');

%dist = rand(1,length(edges))*10;
dist = zeros(1,length(edges));

msize = [length(obj.v)+length(edges),length(obj.v)];

row = [1:length(obj.v),length(obj.v)+[1:length(edges)],length(obj.v)+[1:length(edges)]]';
col = [[1:length(obj.v)]';edges(:,1);edges(:,2)];
val = [ones(length(obj.v),1);ones(length(edges),1);ones(length(edges),1).*-1];

A = sparse(row,col,val,msize(1),msize(2));

for i = 1:3
    b = [obj.v(:,i); dist'];
    obj.v(:,i) = A\b;
end



end