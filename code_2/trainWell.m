function [Data] = trainWell(idx_well, question_well, Data) 
%% Preprocess
% obtain data from specified wells
X=[];Y=[];
for i = 1:numel(idx_well)
    X = [X;Data(idx_well(i)).X];
    Y = [Y;Data(idx_well(i)).Y];
end
% randomize rows
order = randperm(size(X,1));
X = X(order,:);
Y = Y(order,:);
%% Train
% Implement backprop and train network using fminunc
lambda = 0.1;
[Theta1, Theta2, Theta3, Theta4] = train(X, Y, lambda);
%% Test

% training set accuracy
p_train = predict(Theta1, Theta2, Theta3, Theta4, X);
% trace
error_train = 1/size(Y,1)*sum((p_train-Y).^2);
% r-square
y_train_ave = sum(Y)/size(Y,1);
ss_tot = sum((Y-y_train_ave).^2);ss_res = sum((Y-p_train).^2);
r2_train = 1-(ss_res/ss_tot);

fprintf('\nTraining Set Error: %f\n', error_train);
fprintf('\nTraining Set R-square: %f\n', r2_train);

% test set accuracy
for i = 1:numel(Data)
    if ~ismember(i,idx_well) && ~ismember(i,question_well)
        X_test = Data(i).X;
        Y_test = Data(i).Y;
        % predict
        Data(i).p_test = predict(Theta1, Theta2, Theta3, Theta4, X_test);
        % trace
        Data(i).error_test = sum((Data(i).p_test-Y_test).^2)/size(Y_test,1);
        % r-square
        y_test_ave = sum(Y_test)/size(Y_test,1);
        ss_tot = sum((Y_test-y_test_ave).^2);ss_res = sum((Y_test-Data(i).p_test).^2);
        Data(i).ss_tot = ss_tot; Data(i).ss_res = ss_res;
        Data(i).r2_test = 1-(ss_res/ss_tot);
    end
end