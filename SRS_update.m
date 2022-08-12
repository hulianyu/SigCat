function [eva,freq_pi,eva_pi,freq_m,eva_m,eva_2] = SRS_update(freq_pi,eva_pi,freq_m,eva_m,eva_2,x,A,B)
% Locally update Simplified Ratio Statistic (SRS)

freq_pi(A) = freq_pi(A)-1;
eva_pi(A) = times(freq_pi(A),log(freq_pi(A)));
freq_pi(B) = freq_pi(B)+1;
eva_pi(B) = times(freq_pi(B),log(freq_pi(B)));
% eva1
M = length(x);
eva1 = sum(eva_pi);
eva1 = eva1*M;
% eva2
for m=1:M
    xm = x(m);
    % A
    freq_m{m,A}(xm) = freq_m{m,A}(xm)-1;
    tA = freq_m{m,A}(xm);
    tmsA = times(tA,log(tA));
    if tA==0
        tmsA = 0;
    end
    eva_2(m,A) = eva_2(m,A) + tmsA - eva_m{m,A}(xm);
    eva_m{m,A}(xm) = tmsA;
    % B
    freq_m{m,B}(xm) = freq_m{m,B}(xm)+1;
    tB = freq_m{m,B}(xm);
    tmsB = times(tB,log(tB));
    eva_2(m,B) = eva_2(m,B) + tmsB - eva_m{m,B}(xm);
    eva_m{m,B}(xm) = tmsB;
end
eva2 = sum(eva_2(:));
% eva
eva = eva1 - eva2;
if eva < 0 % floating point errors
    eva = 0;
end
end