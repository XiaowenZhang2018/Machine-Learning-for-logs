function [netParams, rmsd_train, r2_train] = trainWell(num, idx_well, Data)

%%%% Preprocess
% obtain data from specified wells
X=[];Y=[];
for ii = 1:numel(idx_well)
    X = [X;Data(idx_well(ii)).X];
    Y = [Y;Data(idx_well(ii)).Y];
end
% randomize rows
order = randperm(size(X,1));
X = X(order,:);
Y = Y(order,:);

%%%%% Train
% Implement backprop and train network using fminunc
if num<4
    lambda = 0.1;
elseif num<6
    lambda = 0.3;
elseif num<8
    lambda = 1;
else
    lambda = 3;
end

% Train Nural Network and save training parameters
[netParams.Theta1, netParams.Theta2] = NNCode.train(X, Y, lambda);

%%%%% Test

% training set accuracy
p_train = NNCode.predict(netParams.Theta1, netParams.Theta2, X);
% trace
rmsd_train = sqrt( 1/size(Y,1)*sum((p_train-Y).^2) );
% r-square
y_train_ave = sum(Y)/size(Y,1);
ss_tot = sum((Y-y_train_ave).^2);ss_res = sum((Y-p_train).^2);
r2_train = 1-(ss_res/ss_tot);

fprintf('\nTraining Set RMDS: %f\n', rmsd_train);
fprintf('\nTraining Set R-square: %f\n', r2_train);