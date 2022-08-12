function [eva,freq_pi,eva_pi,freq_m,eva_m,eva_2] = SRS_init(X, K)
% initialization: pi={X,{},...,{}}
% show elements of Simplified Ratio Statistic (SRS) in X|pi
% eva = eva_1 - eva_2
% eva_1: $M*\sum\limits_{k=1}^{K}(N^{(k)}*\ln {N^{(k)}})$
% eva_2: $\sum\limits_{m=1}^{M}\sum\limits_{k=1}^{K}\sum\limits_{q=1}^{Q^{(k)}_m}...
% ({N_{mq}^{(k)}}*\ln {N_{mq}^{(k)}}).

N = size(X,1);
M = size(X,2);
freq_m = cell(M,K);
eva_m = cell(M,K);
eva_2 = zeros(M,K);
freq_pi = N;
eva_pi = times(freq_pi,log(freq_pi));
% eva1
eva1 = sum(eva_pi);
eva1 = eva1*M;
% eva2
for m=1:M
    max_att = max(X(:,m));
    valueset=1:max_att;
    % k==1
    Xm = X(:,m);
    count= countcats(categorical(Xm,valueset));
    freq_m{m,1} = count;
    tms_m = times(count,log(count));
    eva_m{m,1} = tms_m;
    eva_2(m,1) = sum(tms_m);
    % k=2:K
    count_zero = countcats(categorical(0,valueset));
    for k=2:K
        freq_m{m,k} = count_zero;
        eva_m{m,k} = count_zero;
        eva_2(m,k) = 0;
    end
end
eva2 = sum(eva_2(:,1));
% eva
eva = eva1 - eva2;
end