function [J,grad] = nncostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   X, y, lambda)

% parameters for the neural network are "unrolled" into the vector
% nn_params and need to be converted back into the weight matrices.
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 1, (hidden_layer_size + 1));   
m = size(X, 1); % size of training sets

% feedforward
a1 = [ones(m,1) X];
z2 = a1*Theta1';
a2 = [ones(m,1), NNCode.sigmoid(z2)];
z3 = a2*Theta2';
htheta = NNCode.sigmoid(z3);
% cost
J = -1/m*sum(y.*log(htheta)+(1-y).*log(1-htheta));

% regularization
temp1 = sum(Theta1.^2);
temp2 = sum(Theta2.^2);
J = J+lambda/2/m*(sum(temp1(2:end))+sum(temp2(2:end)));

% backprop
delta_3 = (htheta-y)';
delta_2 = Theta2'*delta_3.*NNCode.sigmoidGradient([ones(m,1),z2])';
Theta1_grad = delta_2(2:end,:)*a1/m;
Theta2_grad = delta_3*a2/m;

% regularization
Theta1_grad(:,2:end) = Theta1_grad(:,2:end)+lambda/m*Theta1(:,2:end);
Theta2_grad(:,2:end) = Theta2_grad(:,2:end)+lambda/m*Theta2(:,2:end);

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];
end