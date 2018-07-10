function g = sigmoidGradient(z)
g = NNCode.sigmoid(z).*(1 - NNCode.sigmoid(z));
end
