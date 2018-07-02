%% Preprocess
% obtain data (features and results)
inputLogs = ['RS'; 'SP'];
outputLog = 'VCL';
[X, Y, idx_data] = obtainData('zonesFile.txt', '172', 'BNS', inputLogs, outputLog);

% normalize feature
%[X, mu, sigma] = featureNormalize(X);

% randomize rows
order = randperm(size(X,1));
X = X(order,:);
Y = Y(order,:);

% percentage of data to use for training
train_frac = 0.7;
% split into training and test sets:
test_rows = round(size(X,1)*(1-train_frac)); %number of rows to use in test set
X_test = X(1:test_rows,:); y_test = Y(1:test_rows,:);%this is the test set
X_train = X(test_rows+1:end,:); y_train = Y(test_rows+1:end,:);%this is the training set
m = size(X_train,1);

%% Train
% Implement backprop and train network using fminunc
fprintf('\nTraining Neural Network... \n')

lambda = 0.03;
[Theta1, Theta2, Theta3, Theta4] = train(X_train, y_train, lambda);

%% Test
% training set accuracy
p_train = predict(Theta1, Theta2, Theta3, Theta4, X_train);
% trace
error_train = 1/size(y_train,1)*sum((p_train-y_train).^2);
% r-square
y_train_ave = sum(y_train)/size(y_train,1);
ss_tot = sum((y_train-y_train_ave).^2);
ss_reg = sum((p_train-y_train_ave).^2);
ss_res = sum((y_train-p_train).^2);
r2_train = 1-(ss_res/ss_tot);

fprintf('\nTraining Set Error: %f\n', error_train);
fprintf('\nTraining Set R-square: %f\n', r2_train);

% test set accuracy
p_test = predict(Theta1, Theta2, Theta3, Theta4, X_test);
% trace
error_test = 1/size(y_test,1)*sum((p_test-y_test).^2);
% r-square
y_test_ave = sum(y_test)/size(y_test,1);
ss_tot = sum((y_test-y_test_ave).^2);
ss_reg = sum((p_test-y_test_ave).^2);
ss_res = sum((y_test-p_test).^2);
r2_test = 1-(ss_res/ss_tot);

fprintf('\nTest Set Error: %f\n', error_test);
fprintf('\nTest Set R-square: %f\n', r2_test);

%% Sort and Write
[order, idx_order] = sort(order);
Y = [p_test; p_train]; Y = Y(idx_order,:);
result = -999.0000.*ones(size(idx_data,1),1);
result(idx_data) = Y;
fid = fopen('cal.txt','wt');
fprintf(fid,'%9.4f\n',result);
fclose(fid);