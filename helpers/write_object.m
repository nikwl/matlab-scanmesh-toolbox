function [] = write_object(objname,obj)
% Writes an obj to file
%
% Inputs:
%   objname  -  filename of obj
% 	obj      -  obj struct to be written, with fields: 
%    .v      -  vertex coordinates
%    .vc     -  vertex colors (can be empty)
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

try
% Open the file
fid = fopen(objname,'w');

% Print header
fprintf(fid,'# %d vertices, %d faces\n',length(obj.v),length(obj.f));

% Find max vertex parameter
maxs = max([length(obj.v),length(obj.vc),length(obj.vt),length(obj.vn)]);

% Initialize conditionals
if isfield(obj,'vc'), writevc = ~isempty(obj.vc); lenvc = length(obj.vc); else, writevc = false; end
if isfield(obj,'vt'), writevt = ~isempty(obj.vt); lenvt = length(obj.vt); else, writevt = false; end
if isfield(obj,'vn'), writevn = ~isempty(obj.vn); lenvn = length(obj.vn); else, writevn = false; end
if isfield(obj,'ft'), writeft = ~isempty(obj.ft); lenft = length(obj.ft); else, writeft = false; end
if isfield(obj,'fn'), writefn = ~isempty(obj.fn); lenfn = length(obj.fn); else, writefn = false; end

% Print vertices 
for vcount = 1:maxs
    if (vcount <= length(obj.v))
        if (writevc == true && vcount <= lenvc)
            fprintf(fid,'v %f %f %f %f %f %f\n',obj.v(vcount,1),obj.v(vcount,2),obj.v(vcount,3),obj.vc(vcount,1),obj.vc(vcount,2),obj.vc(vcount,3));
        else
            fprintf(fid,'v %f %f %f\n',obj.v(vcount,1),obj.v(vcount,2),obj.v(vcount,3));
        end
    end
    if (writevt == true && vcount <= lenvt)
        fprintf(fid,'vt %f %f\n',obj.vt(vcount,1),obj.vt(vcount,2));
    end
    if (writevn == true && vcount <= lenvn)
        fprintf(fid,'vn %f %f %f\n',obj.vn(vcount,1),obj.vn(vcount,2),obj.vn(vcount,3));
    end    
end

% Only write faces
if (writeft == false && writefn == false)
    for fcount = 1:length(obj.f)
        fprintf(fid,'f %d %d %d\n',obj.f(fcount,1),obj.f(fcount,2),obj.f(fcount,3));
    end
% Write faces and face texture
elseif (writeft == true && writefn == false)
    for fcount = 1:length(obj.f)
        if (fcount <= lenft) 
            fprintf(fid,'f %d/%d %d/%d %d/%d\n',obj.f(fcount,1),obj.ft(fcount,1),obj.f(fcount,2),obj.ft(fcount,2),obj.f(fcount,3),obj.ft(fcount,3));
        else
            fprintf(fid,'f %d %d %d\n',obj.f(fcount,1),obj.f(fcount,2),obj.f(fcount,3));
        end
    end
% Write faces and face normals
elseif (writeft == false && writefn == true)
    for fcount = 1:length(obj.f)
        if (fcount <= lenfn) 
            fprintf(fid,'f %d//%d %d//%d %d//%d\n',obj.f(fcount,1),obj.fn(fcount,1),obj.f(fcount,2),obj.fn(fcount,2),obj.f(fcount,3),obj.fn(fcount,3));
        else
            fprintf(fid,'f %d %d %d\n',obj.f(fcount,1),obj.f(fcount,2),obj.f(fcount,3));
        end
    end
% Write faces, face textures, and face normals
elseif (writeft == true && writefn == true)
    for fcount = 1:length(obj.f)
        if (fcount <= lenft && fcount <= lenfn) 
            fprintf(fid,'f %d/%d/%d %d/%d/%d %d/%d/%d\n',obj.f(fcount,1),obj.ft(fcount,1),obj.fn(fcount,1),obj.f(fcount,2),obj.ft(fcount,2),obj.fn(fcount,2),obj.f(fcount,3),obj.ft(fcount,3),obj.fn(fcount,3));
        elseif (fcount <= lenft) 
            fprintf(fid,'f %d/%d %d/%d %d/%d\n',obj.f(fcount,1),obj.ft(fcount,1),obj.f(fcount,2),obj.ft(fcount,2),obj.f(fcount,3),obj.ft(fcount,3));
        elseif (fcount <= lenfn) 
            fprintf(fid,'f %d//%d %d//%d %d//%d\n',obj.f(fcount,1),obj.fn(fcount,1),obj.f(fcount,2),obj.fn(fcount,2),obj.f(fcount,3),obj.fn(fcount,3));            
        else
            fprintf(fid,'f %d %d %d\n',obj.f(fcount,1),obj.f(fcount,2),obj.f(fcount,3));
        end
    end
end

% Close file
fclose(fid);

catch ME
    fclose(fid);
    error(ME.message);
end

end