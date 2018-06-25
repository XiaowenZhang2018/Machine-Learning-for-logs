%% Preprocess
% obtain data (features and results)
inputLogs = ['RD'; 'SP'];
outputLog = 'VCL';
[X,Y] = obtainData('zonesFile.txt', '172', 'BNS', inputLogs, outputLog);

% normalize feature
%[X, mu, sigma] = featureNormalize(X);

% randomize rows(Does it need for logs?)
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
[Theta1, Theta2, Theta3] = train(X_train, y_train, lambda);

%% Test
% training set accuracy
p_train = predict(Theta1, Theta2, Theta3, X_train);
error_train = 1/m*sum((p_train-y_train).^2);
fprintf('\nTraining Set Error: %f\n', error_train);
% test set accuracy
p_test = predict(Theta1, Theta2, Theta3, X_test);
error_test = 1/m*sum((p_test-y_test).^2);
fprintf('\nTest Set Error: %f\n', error_test);
