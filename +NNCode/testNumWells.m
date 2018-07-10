function s_allRes = testNumWells(inputLogs, outputLog, well_index, test_num, seed)

% Initialize output data structure, and save inputs
s_allRes = struct;
s_allRes(1).inputLogs = inputLogs;
s_allRes(1).well_index = well_index;
s_allRes(1).outputLog = outputLog;
s_allRes(1).test_num = test_num;
s_allRes(1).seed = seed;

%%%% Define inputs
switch getenv('username')
    case 'ja43578'
        pInputData = 'C:\Users\ja43578\Box Sync\master project\Full Data\';
        pRunData = 'C:\Users\ja43578\Box Sync\master project\RunData\';
        pCode = 'C:\Users\ja43578\Documents\GitHub\Machine-Learning-for-logs';
end

% Add github folder w code
addpath(pCode)

% Initialize seed
seed = RandStream('mt19937ar','Seed',seed);

% Load Project
utap.loadProject([pRunData 'allWellsData.mat']);
csf = utap.rCSF;


% Obtain data (features and results)
[allData] = NNCode.obtainData(csf, [pInputData 'zones_simple.txt'], ...
    'BNS', inputLogs, outputLog);

for num = 1:12
    
    % Generate sets of wells to be used as training sets
    if num == 1
        a_train_wells = well_index';
    else
        acceptedNumSets = 0;
        a_train_wells = [];
        while acceptedNumSets < test_num
            
            % Randomly choose num wells and append to well_sets
            temp = well_index( randperm( seed, numel(well_index) ) );
            a_train_wells(end+1,:) = sort(temp(1:num));
            
            % Make sure there are no repeated well idx combinations
            a_train_wells = unique(a_train_wells, 'rows');
            
            acceptedNumSets = size(a_train_wells,1);
        end
    end
    
    s_allRes(num).a_train_wells = a_train_wells;
    
    % Go over the proposed training sets
    for count = 1:size(a_train_wells,1)
        choose_well = a_train_wells(count,:);
        
        % Train network using wells set within "choose_well"
        [netParams, rmsd_train, r2_train] = ...
            NNCode.trainWell(num, choose_well, allData);
        
        s_allRes(num).rmsd_train(count) = rmsd_train;
        s_allRes(num).r2_train(count) = r2_train;
        
        % Go over test wells (all except training set) and put together in
        % a single data array
        a_validIdx = setdiff(well_index, choose_well);
        a_X = vertcat(allData(a_validIdx).X);
        a_Y = vertcat(allData(a_validIdx).Y);
        
        % Predict data from all wells
        a_Ypredicted = NNCode.predict(netParams.Theta1, netParams.Theta2, a_X);
        
        % Trace
        rmsd_test = sqrt( 1/size(a_Y,1)*sum((a_Ypredicted - a_Y).^2) );
        % R2
        a_Yavg = sum(a_Y)/size(a_Y,1);
        ss_tot = sum((a_Y - a_Yavg).^2);
        ss_res = sum((a_Y - a_Ypredicted).^2);
        r2_test = 1 - (ss_res/ss_tot);
        
        fprintf('\nTest Set Error: %f\n', rmsd_test);
        fprintf('\nTest Set R-square: %f\n', r2_test);
        
        
        s_allRes(num).rmsd_test(count) = rmsd_test;
        s_allRes(num).r2_test(count) = r2_test;
    end
    
    s_allRes(num).avg_rmsd_train = mean(s_allRes(num).rmsd_train);
    s_allRes(num).std_rmsd_train = std(s_allRes(num).rmsd_train);
    s_allRes(num).avg_r2_train = mean(s_allRes(num).r2_train);
    s_allRes(num).std_r2_train = std(s_allRes(num).r2_train);
    s_allRes(num).avg_rmsd_test = mean(s_allRes(num).rmsd_test);
    s_allRes(num).std_rmsd_test = std(s_allRes(num).rmsd_test);
    s_allRes(num).avg_r2_test = mean(s_allRes(num).r2_test);
    s_allRes(num).std_r2_test = std(s_allRes(num).r2_test);
    
end

end