function eva = SRS(Xm,pi)
% Simplified Ratio Statistic (SRS)
M = size(Xm,2);
K = max(pi);
eva_mk = zeros(M,K);
freq_pi = countcats(categorical(pi));
eva1 = sum(times(freq_pi,log(freq_pi)));
eva1 = eva1*M;
for m=1:M
    for k=1:K
        tmp_m = Xm(pi==k,m);
        freq = countcats(categorical(tmp_m));
        eva_q = times(freq,log(freq));
        eva_mk(m,k) = sum(eva_q);
    end
end
eva2 = sum(eva_mk(:));
eva = eva1 - eva2;
end