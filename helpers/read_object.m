function [obj] = read_object(fname)
% Reads in an object from file. Compatable with Wavefront OBJ file formats.
%    Will parse vertices, vertex textures, vertex normals, faces, face
%    textures, face normals. All other data is ignored. Does not associate 
%    with image or material files. To accelerate processing files can have
%    a header that specifies number of vertices and faces. If no header is
%    found arrays are initialized to the entire length of the file using os
%    command. If os is not supported arrays are initialized to 1 million
%    entries. 
%
% Inputs:
%    fname  -  filename of obj
% Outputs: 
%    obj    -  obj struct, with fields: 
%     .v    -  vertex coordinates
%     .vc   -  vertex color (can be empty)
%	  .vt   -  vertex textures (can be empty)
%	  .vn   -  vertex normals (can be empty)
%	  .f    -  faces by index
%	  .ft   -  face textures (can be empty) 
%	  .fn   -  face normals (can be empty)
% 
% Example: 
%
% Copyright (c) 2018 Nikolas Lamb
%

% Open the file
fid=fopen(fname);

% Error if filenotfound
if fid<0
    error( ['Cannot open ' fname '.'] );
end

% Initialize array max (for speed)
maxs = [];

% Get line
line=fgets( fid );

% Read in header and assign value to max
while line(1) == '#'
    if length(sscanf( line, '# %f vertices, %f faces' ))  == 2
        maxs = sscanf( line, '# %f vertices, %f faces' );
    elseif ~isempty(sscanf( line, '# Vertices: %f' ))
        maxs(1) = sscanf( line, '# Vertices: %f' );
    elseif ~isempty(sscanf( line, '# Faces: %f' ))
        maxs(2) = sscanf( line, '# Faces: %f' );
    end
    line=fgets( fid );
end

% If header is not configred, init arrays to length of file
if isempty(maxs)
    % Use system call to determine length of file
    if (ismac || isunix)
        [status, cmdout]= system('wc -l filenameOfInterest.txt');
        if(status~=1)
            scanCell = textscan(cmdout,'%u %s');
            maxs(1) = scanCell{3};
            maxs(2) = scanCell{3};
        end
    elseif ispc
        [status, cmdout] = system(['find /c /v "" ',fname]);
        if(status~=1)
            scanCell = textscan(cmdout,'%s %s %u');
            maxs(1) = scanCell{3};
            maxs(2) = scanCell{3};
        end
    end
    
    % If system cannot determine file lenght, init arrays to 1000000
    if (isempty(maxs))
        warning('Failed to determine file length, arrays initialized to 1000000 entries')
        maxs(1) = 1000000;
        maxs(2) = 1000000;
    end
end

% Initialize arrays (for speed)
v=zeros( maxs(1),3 );
vc=zeros( maxs(1),3 );
vt=zeros( maxs(1),2 );
vn=zeros( maxs(1),3 );
f=zeros( maxs(2),3 );
ft=zeros( maxs(2),3 );
fn=zeros( maxs(2),3 );

% Initialize incrementors
vcount = 1;
vccount = 1;
vtcount = 1;
vncount = 1;
fcount = 1;
ftcount = 1;
fncount = 1;

% Rewind to avoid missing vertices
frewind( fid );

% Continue reading
while line ~= -1
    line = fgets( fid );
    switch line(1)
        case 'v'
            switch line(2)
                case 'n'
                    % vertex normal
                    vn(vncount,:) = sscanf( line, 'vn %f %f %f' );
                    vncount = vncount + 1;
                case 't'
                    % texture coord
                    vt(vtcount,:) = sscanf( line, 'vt %f %f' );
                    vtcount = vtcount + 1;
                otherwise
                    % vertex
                    a = sscanf( line, 'v %f %f %f %f %f %f' );
                    % if present, extract vertex color
                    switch length(a)
                        case 3
                            v(vcount,:) = a;
                            vcount = vcount + 1;
                        case 6 
                            v(vcount,:) = a(1:3);
                            vc(vccount,:) = a(4:6);
                            vcount = vcount + 1;
                            vccount = vccount + 1;
                    end
            end
        case 'f'
            faces = sscanf( line , 'f %d %d %d' );
            if (length(faces) == 3) 
                % face
                f(fcount,:) = faces(1:1:end);
                fcount = fcount + 1;
                continue
            end          
            faces = sscanf( line , 'f %d/%d %d/%d %d/%d' );
            if (length(faces) == 6)
                % face and texture
                f(fcount,:) = faces(1:2:end);
                ft(fcount,:) = faces(2:2:end);
                fcount = fcount + 1;
                ftcount = ftcount + 1;
                continue
            end
            faces = sscanf( line , 'f %d/%d/%d %d/%d/%d %d/%d/%d' );
            if (length(faces) == 9) 
                % face and texture and normal
                f(fcount,:) = faces(1:3:end);
                ft(fcount,:) = faces(2:3:end);
                fn(fcount,:) = faces(3:3:end);
                fcount = fcount + 1;
                ftcount = ftcount + 1;
                fncount = fncount + 1;
                continue
            end
            faces = sscanf( line , 'f %d//%d %d//%d %d//%d' );
            if (length(faces) == 6) 
                % face and normal
                f(fcount,:) = faces(1:2:end);
                fn(fcount,:) = faces(2:2:end);
                fcount = fcount + 1;
                fncount = fncount + 1;
                continue
            end
    end
end

% Delete unused array portions
v(vcount:end,:)=[];
vc(vccount:end,:)=[];
vt(vtcount:end,:)=[];
vn(vncount:end,:)=[];
f(fcount:end,:)=[];
ft(ftcount:end,:)=[];
fn(fncount:end,:)=[];

% Assign to struct
obj.v = v;
obj.vc = vc;
obj.vt = vt;
obj.vn = vn;
obj.f = f;
obj.ft = ft;
obj.fn = fn;

% Close file
fclose(fid);

end