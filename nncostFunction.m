function [J grad] = nn_costFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   X, y, lambda)

% parameters for the neural network are "unrolled" into the vector
% nn_params and need to be converted back into the weight matrices.
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));
Theta2 = reshape(nn_params(1 + hidden_layer_size * (input_layer_size + 1):hidden_layer_size*(hidden_layer_size+1)+hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (hidden_layer_size + 1));
Theta3 = reshape(nn_params(1+hidden_layer_size*(hidden_layer_size+1)+hidden_layer_size * (input_layer_size + 1):end), ...
                 1,(hidden_layer_size+1));
m = size(X, 1); % size of training sets
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));
Theta3_grad = zeros(size(Theta3));
% feedforward
a1 = [ones(m,1) X];
z2 = a1*Theta1';
a2 = [ones(m,1),sigmoid(z2)];
z3 = a2*Theta2';
a3 = [ones(m,1),sigmoid(z3)];
z4 = a3*Theta3';
a4 = z4;
% cost
J = -1/m*sum((a4-y).^2);
% regularization
temp1 = sum(Theta1.^2);
temp2 = sum(Theta2.^2);
temp3 = sum(Theta3.^2);
J = J+lambda/2/m*(sum(temp1(2:end))+sum(temp2(2:end))+sum(temp3(2:end)));
% backprop
for t = 1:m
    delta_4 = a4(t)-y(t);
    delta_3 = Theta3'*delta_4.*sigmoidGradient([1,z3(t,:)])';
    delta_2 = Theta2'*delta_3(2:end).*sigmoidGradient([1,z2(t,:)])';    
    Theta1_grad = Theta1_grad+delta_2(2:end)*a1(t,:);
    Theta2_grad = Theta2_grad+delta_3(2:end)*a2(t,:);
    Theta3_grad = Theta3_grad+delta_4*a3(t,:);
end
% regularization
Theta1_grad = Theta1_grad/m;
Theta2_grad = Theta2_grad/m;
Theta3_grad = Theta3_grad/m;
Theta1_grad(:,2:end) = Theta1_grad(:,2:end)+lambda/m*Theta1(:,2:end);
Theta2_grad(:,2:end) = Theta2_grad(:,2:end)+lambda/m*Theta2(:,2:end);
Theta3_grad(:,2:end) = Theta3_grad(:,2:end)+lambda/m*Theta3(:,2:end);
% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:) ; Theta3_grad(:)];
end