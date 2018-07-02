clear
clc
% obtain data (features and results)
inputLogs = ['RS'; 'SP'];
outputLog = 'VCL';
[Data] = obtainData('zonesFile.txt', 'BNS', inputLogs, outputLog);
% choose wells to train
well_index = [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
num = 2;
well_sets = zeros(10,num);
for t = 1:10
    temp = well_index(randperm(numel(well_index)));% randomly choose num wells
    well_sets(t,:)=temp(1:num);
end

question_well = [1,2,3,4];

for count = 1:size(well_sets,1)
    
if size(well_sets,1) == 1
    choose_well = well_sets;
else
    choose_well = well_sets(count,:);
end
[Data] = trainWell(choose_well, question_well, Data);

% Save calculated log
error = 0;
size_test = 0;
y_total = 0;
ss_tot = 0;
ss_res = 0;
for i = 1:numel(Data)
    if ~ismember(i,choose_well) && ~ismember(i,question_well)
        %result = -999.0000.*ones(size(Data(i).idx_data,1),1); %recover data size
        %result(Data(i).idx_data) = Data(i).p_test;
        %Data(i).log_cal = result;
        %idx_well = find(strcmp(Data(i).wellID,{proj.CSF.a_Wells.API}));
        %logs = proj.CSF.a_Wells(idx_well).a_logSets.a_logs;
        %idx_log = strcmp(outputLog,{logs.name});
        %proj.CSF.a_Wells(i).a_logSets.a_logs(33) = logs(idx_log);
        %proj.CSF.a_Wells(i).a_logSets.a_logs(33).rawData = Data(i).log_cal;
        %calculate trace and r-square
        error = error + Data(i).error_test*size(Data(i).Y,1);
        size_test = size_test+size(Data(i).Y,1);
        y_total = y_total+sum(Data(i).Y);
        ss_tot = ss_tot + Data(i).ss_tot;
        ss_res = ss_res + Data(i).ss_res;
    end
end
well_90 = [];
well_80 = [];
for i = 1:numel(Data)
    if Data(i).r2_test
        if Data(i).r2_test>0.9
            well_90 = [well_90, i];
        end
        if Data(i).r2_test>0.8 && Data(i).r2_test<0.9
            well_80 = [well_80, i];
        end  
    end
end
error_test = error/size_test;
y_test_ave = y_total/size_test;
r2_test = 1-(ss_res/ss_tot);
fprintf('\nTest Set Error: %f\n', error_test);
fprintf('\nTest Set R-square: %f\n', r2_test);
if ~exist('result', 'var')
    idx = 1;
else
    idx = numel(result)+1;
end
result(idx).well_sets = well_sets(count,:);
result(idx).r2_test = r2_test;
result(idx).well_90 = well_90;
result(idx).well_80 = well_80;

end