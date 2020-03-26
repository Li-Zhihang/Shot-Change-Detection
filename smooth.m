function S_smoothed = smooth(S)
% parameters
len_s = length(S);
nIters = 100;
lambda = 0.1;
k = 0.1;

S_t = zeros(len_s, nIters); % each column stores the new values
S_t(:, 1) = S;

for t = 2: nIters
    delta_e = [S_t(2: len_s, t - 1); S_t(len_s, t - 1)] - S_t(: , t - 1);
    delta_w = [S_t(1, t - 1); S_t(1: len_s - 1, t - 1)] - S_t(: , t - 1);
    c_e = exp(-(norm(delta_e) / k) ^ 2);
    c_w = exp(-(norm(delta_w) / k) ^ 2);
    
    S_t(: , t) = S_t(: , t - 1) + lambda * (c_e * delta_e + c_w * delta_w);
end
S_smoothed = S_t(: , nIters);

end