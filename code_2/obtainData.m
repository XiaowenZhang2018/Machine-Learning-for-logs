function [Data] = obtainData(fileName, zone, inputLogs, outputLog)
% This function is to obtain data from specified project, specified zone
% and specified logs for all wells. This function will automically delete
% NaN data and wells have no proper data or zone.
% Data contains X (features) and Y (results)

% find depth range of specified zone in zonesFile for all wells
wells_zones = readWellZones(fileName);
proj = load('allWellsData.mat');

for i = 1:numel(wells_zones)    
    % find depth range of specified zone in each well
    idx_zone = find(strcmp(zone,{wells_zones(i).a_zones.zoneName})); % which zone
    if idx_zone
        
        top = str2double(wells_zones(i).a_zones(idx_zone).top);
        bottom = str2double(wells_zones(i).a_zones(idx_zone).bottom);

        logs = proj.CSF.a_Wells(i).a_logSets.a_logs;
        depth = logs.depthData;
        
        X = zeros(size(depth,1),size(inputLogs,1));
        idx_data = ones(size(depth,1),1);
        for j = 1:size(inputLogs,1)
            idx_log = strcmp(inputLogs(j,:),{logs.name}); % which log
            X(:,j) = logs(idx_log).rawData; % obtain log data
            idx_data = idx_data.*(X(:,j) > -900);% obtain meanningful datas' intersection(dismiss NaN)
        end
        
        
        idx_log = strcmp(outputLog,{logs.name});
        Y = logs(idx_log).rawData;
        idx_data = idx_data.*(Y > -900).*(depth > top & depth < bottom);% find intersection of 
        idx_data = logical(idx_data);                                   % focus depth and meaningful data
        
        if find(idx_data)
            if ~exist('Data', 'var')
                idx = 1;
            else
                idx = numel(Data)+1;
            end
            Data(idx).wellID = wells_zones(i).wellID;
            Data(idx).idx_data = idx_data;     
            
            % obtain learning data for each well  
            Data(idx).X = X(idx_data,:);
            Data(idx).Y = Y(idx_data);
        end
    end
end

end