function [J grad] = nn_costFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   X, y, lambda)

% parameters for the neural network are "unrolled" into the vector
% nn_params and need to be converted back into the weight matrices.
hidden_theta_size = hidden_layer_size*(hidden_layer_size+1);
input_theta_size = hidden_layer_size * (input_layer_size + 1);

Theta1 = reshape(nn_params(1:input_theta_size), hidden_layer_size, (input_layer_size + 1));
Theta2 = reshape(nn_params(1 + input_theta_size:hidden_theta_size + input_theta_size), ...
                 hidden_layer_size, (hidden_layer_size + 1));
Theta3 = reshape(nn_params(1+hidden_theta_size+input_theta_size:2*hidden_theta_size+input_theta_size), ...
                 hidden_layer_size,(hidden_layer_size+1));
Theta4 = reshape(nn_params(1+2*hidden_theta_size+input_theta_size:end), ...
                 1,(hidden_layer_size+1));          
m = size(X, 1); % size of training sets

% feedforward
a1 = [ones(m,1) X];
z2 = a1*Theta1';
a2 = [ones(m,1),sigmoid(z2)];
z3 = a2*Theta2';
a3 = [ones(m,1),sigmoid(z3)];
z4 = a3*Theta3';
a4 = [ones(m,1),sigmoid(z4)];
z5 = a4*Theta4';
htheta = sigmoid(z5);
% cost
J = -1/m*sum(y.*log(htheta)+(1-y).*log(1-htheta));

% regularization
temp1 = sum(Theta1.^2);
temp2 = sum(Theta2.^2);
temp3 = sum(Theta3.^2);
temp4 = sum(Theta4.^2);
J = J+lambda/2/m*(sum(temp1(2:end))+sum(temp2(2:end))+sum(temp3(2:end))+sum(temp4(2:end)));

% backprop
delta_5 = (htheta-y)';
delta_4 = Theta4'*delta_5.*sigmoidGradient([ones(m,1),z4])';
delta_3 = Theta3'*delta_4(2:end,:).*sigmoidGradient([ones(m,1),z3])';
delta_2 = Theta2'*delta_3(2:end,:).*sigmoidGradient([ones(m,1),z2])';
Theta1_grad = delta_2(2:end,:)*a1/m;
Theta2_grad = delta_3(2:end,:)*a2/m;
Theta3_grad = delta_4(2:end,:)*a3/m;
Theta4_grad = delta_5*a4/m;

% regularization
Theta1_grad(:,2:end) = Theta1_grad(:,2:end)+lambda/m*Theta1(:,2:end);
Theta2_grad(:,2:end) = Theta2_grad(:,2:end)+lambda/m*Theta2(:,2:end);
Theta3_grad(:,2:end) = Theta3_grad(:,2:end)+lambda/m*Theta3(:,2:end);
Theta4_grad(:,2:end) = Theta4_grad(:,2:end)+lambda/m*Theta4(:,2:end);

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:) ; Theta3_grad(:) ; Theta4_grad(:)];
end