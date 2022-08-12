function [k_hat,w_] = mGap(rk,w_data,maxK)
% modified Gap statistic (Gap^*)
k = 2:maxK;
w_random_s = std(rk,1);
w_random = mean(rk,1);
w_ = ((w_random - w_data)./k)./w_random_s;
[~,w_b] = max(w_);
k_hat = w_b+1;
end