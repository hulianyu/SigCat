function [eva,freq_pi,freq_m,eva_m,eva_2] = EE_init(X,K)
% initialization: pi={X,{},...,{}}
% show elements of EE

N = size(X,1);
M = size(X,2);
freq_m = cell(M,K);
eva_m = cell(M,K);
freq_pi = N;
eva_2 = zeros(M,K);
for m=1:M
    max_att = max(X(:,m));
    valueset=1:max_att;
    % k==1
    Xm = X(:,m);
    count= countcats(categorical(Xm,valueset));
    freq_m{m,1} = count;
    tms_m = times(count,log(count./freq_pi))+times(freq_pi-count,log((freq_pi-count)./freq_pi));
    eva_m{m,1} = tms_m;
    eva_2(m,1) = sum(tms_m);
    count_zero = countcats(categorical(0,valueset));
    for k=2:K
        freq_m{m,k} = count_zero;
        eva_m{m,k} = count_zero;
        eva_2(m,k) = 0;
    end
end
eva = -sum(eva_2(:))/N;
end