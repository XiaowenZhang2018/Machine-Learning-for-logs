function [X, Y] = obtainData(fileName, well, zone, inputLogs, outputLog)
% This function is to obtain data from designed project, designed well,
% designed zone and designed logs. Data contains X (features) and Y (results)

wells = readWellZones(fileName);
idx_well = find(strcmp(well,{wells.wellID})); % which well
idx_zone = find(strcmp(zone,{wells(idx_well).a_zones.zoneName})); % which zone
top = str2double(wells(idx_well).a_zones(idx_zone).top);
bottom = str2double(wells(idx_well).a_zones(idx_zone).bottom);

proj = load('UTAPData.mat');
logs = proj.CSF.a_Wells.a_logSets.a_logs;

% obtain features X
X = [];
for i = 1:size(inputLogs,1)
    idx_log = find(strcmp(inputLogs(i,:),{logs.name}));
    idx_data = logs(idx_log).depthData > top & logs(idx_log).depthData < bottom;
    X(:,i) = logs(idx_log).rawData(idx_data);
end

% obtain results Y
idx_log = find(strcmp(outputLog,{logs.name}));
idx_data = logs(idx_log).depthData > top & logs(idx_log).depthData < bottom;
Y = logs(idx_log).rawData(idx_data);

end