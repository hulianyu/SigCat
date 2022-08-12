function [eva,freq_pi,freq_mk,eva_mk,eva_2] = EE_update(freq_pi,freq_mk,eva_mk,eva_2,X,A,B)
% Locally update EE
M = length(X);
freq_pi(A) = freq_pi(A)-1;
freq_pi(B) = freq_pi(B)+1;
% eva2
for m=1:M
    % A
    freq_mk{m,A}(X(m)) = freq_mk{m,A}(X(m))-1;
    N_jA1 = freq_mk{m,A};
    N_jA0 = freq_pi(A) - freq_mk{m,A};
    tmpA = times(N_jA1,log(N_jA1./freq_pi(A)))+times(N_jA0,log(N_jA0./freq_pi(A)));
    tmpA(isnan(tmpA)) = 0;
    eva_mk{m,A} = tmpA;
    eva_2(m,A) = sum(tmpA);
    % B
    freq_mk{m,B}(X(m)) = freq_mk{m,B}(X(m))+1;
    N_jB1 = freq_mk{m,B};
    N_jB0 = freq_pi(B) - freq_mk{m,B};
    tmpB = times(N_jB1,log(N_jB1./freq_pi(B)))+times(N_jB0,log(N_jB0./freq_pi(B)));
    tmpB(isnan(tmpB)) = 0;
    eva_mk{m,B} = tmpB;
    eva_2(m,B) = sum(tmpB);
end
eva = -sum(eva_2(:))./sum(freq_pi);
end