function a_wells = readWellZones(fileName)
% Read zones_simple.txt file, and generate an array of structures, each
% structure corresponds to a well, and has the following arch
%   a_wells.wellID
%          .a_zones.zoneName
%                  .top
%                  .bottom

fid = fopen(fileName);

while ~feof(fid)
    line = fgetl(fid);
    if size(line,2) > 10 && strcmp(line(1:6), 'Landau')
        c_l = strsplit( strtrim(line) );
        
        % Get wellID
        if size(c_l,2) > 5
            wellID = [c_l{2} ' ' c_l{3}];
            zoneName = c_l{4};
            top = c_l{5};
            bottom = c_l{6};
        else
            wellID = c_l{2};
            zoneName = c_l{3};
            top = c_l{4};
            bottom = c_l{5};
        end
        
        if ~exist('a_wells', 'var') == 1
            idx = 1;
            a_wells(idx).wellID = wellID;
        else
            % Check if well already exists
            idx = find( strcmp(wellID, {a_wells.wellID}), 1);
            if isempty(idx)
                idx = numel(a_wells) + 1;
                a_wells(idx).wellID = wellID;
            end
        end
        
        % a_zones
        if ~isfield(a_wells(idx), 'a_zones')
            zIdx = 1;
        else
            zIdx =  numel( a_wells(idx).a_zones ) + 1;
        end
        a_wells(idx).a_zones(zIdx) = struct('zoneName', zoneName, ...
            'top', top, 'bottom', bottom);
    end
end
fclose(fid);