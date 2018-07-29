function [] = write_object(objname,obj)
% Writes an obj to file
%
% Inputs:
%   objname  -  filename of obj
% 	obj      -  obj struct to be written, with fields: 
%    .v      -  vertex coordinates
%	 .vt     -  vertex textures (can be empty)
%	 .vn     -  vertex normals (can be empty)
%	 .f      -  faces by index
%	 .ft     -  face textures (can be empty) 
%	 .fn     -  face normals (can be empty)
% 
% Example: 
%
% Copyright (c) 2018 Nikolas Lamb
%

% Open the file
fid=fopen(objname,'w');

% Print header
fprintf(fid,'# %d vertices, %d faces\n',length(obj.v),length(obj.f));

% Find max vertex parameter
maxs = max([length(obj.v),length(obj.vt),length(obj.vn)]);

% Initialize conditionals
writevt = ~isempty(obj.vt);
writevn = ~isempty(obj.vn);
writeft = ~isempty(obj.ft);
writefn = ~isempty(obj.fn);

% Print vertices 
for vcount = 1:maxs
    if (vcount <= length(obj.v))
        fprintf(fid,'v %f %f %f\n',obj.v(vcount,1),obj.v(vcount,2),obj.v(vcount,3));
    end
    if (writevt == true && vcount <= length(obj.vt))
        fprintf(fid,'vt %f %f\n',obj.vt(vcount,1),obj.vt(vcount,2));
    end
    if (writevn == true && vcount <= length(obj.vn))
        fprintf(fid,'vn %f %f %f\n',obj.vn(vcount,1),obj.vn(vcount,2),obj.vn(vcount,3));
    end    
end

% Print faces 
if (writeft == false && writefn == false)
    for fcount = 1:length(obj.f)
        fprintf(fid,'f %d %d %d\n',obj.f(fcount,1),obj.f(fcount,2),obj.f(fcount,3));
    end
elseif (writeft == true && writefn == false)
    for fcount = 1:length(obj.f)
        fprintf(fid,'f %d/%d %d/%d %d/%d\n',obj.f(fcount,1),obj.ft(fcount,1),obj.f(fcount,2),obj.ft(fcount,2),obj.f(fcount,3),obj.ft(fcount,3));
    end
elseif (writeft == false && writefn == true)
    for fcount = 1:length(obj.f)
        fprintf(fid,'f %d//%d %d//%d %d//%d\n',obj.f(fcount,1),obj.fn(fcount,1),obj.f(fcount,2),obj.fn(fcount,2),obj.f(fcount,3),obj.fn(fcount,3));
    end
elseif (writeft == true && writefn == true)
    for fcount = 1:length(obj.f)
        fprintf(fid,'f %d/%d/%d %d/%d/%d %d/%d/%d\n',obj.f(fcount,1),obj.ft(fcount,1),obj.fn(fcount,1),obj.f(fcount,2),obj.ft(fcount,2),obj.fn(fcount,2),obj.f(fcount,3),obj.ft(fcount,3),obj.fn(fcount,3));
    end
end

% Close file
fclose(fid);

end