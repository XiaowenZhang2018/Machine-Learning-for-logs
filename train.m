function [Theta1, Theta2, Theta3] = train(X_train, y_train, lambda)

%NN layer sizes
input_layer_size = size(X_train,2);
hidden_layer_size = 3; %output layer size = 1

%Initialize NN Parameters for the 4-layer NN
initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, hidden_layer_size);
initial_Theta3 = randInitializeWeights(hidden_layer_size, 1);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:) ; initial_Theta3(:)];

% Set options for fminunc
options = optimset('GradObj', 'on', 'MaxIter', 400);
costFunction = @(p)nncostFunction(p, input_layer_size, hidden_layer_size, X_train, y_train, lambda);

% Get parameters using fminunc
[nn_params, cost] = fminunc(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params(1 + hidden_layer_size * (input_layer_size + 1):hidden_layer_size*(hidden_layer_size+1)+hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (hidden_layer_size + 1));
             
Theta3 = reshape(nn_params(1+hidden_layer_size*(hidden_layer_size+1)+hidden_layer_size * (input_layer_size + 1):end), ...
                 1, (hidden_layer_size + 1));
end