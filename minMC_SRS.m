function [eva0,pi] = minMC_SRS(X,K,eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva_2_0)
% Minimize Simplified Ratio Statistic (SRS)
% A Monte-Carlo method accepts any better solutions instead of performing systematic searches.

N = size(X,1);
pi0 = ones(N,1);
pi = pi0;
no_change = 0;
freq_pi0(2:K,1) = 0;
eva_pi0(2:K,1) = 0;
patience = (K-1)*N;
G = 1:K;
while no_change<=patience
    % Randomly pick a point x form A
    x = randperm(N,1);
    A = pi(x);
    % Randomly pick another cluster B
    setB = G;
    setB(A) = [];
    B = setB(randperm(size(setB,2),1));
    % Put x into B
    pi(x)=B;
    % Compute the SRS
    xa = X(x,:);
    [eva,freq_pi,eva_pi,freq_m,eva_m,eva_2] = SRS_update(freq_pi0,eva_pi0,freq_m0,eva_m0,eva_2_0,xa,A,B);
    % Compare the result
    if eva<eva0
        eva0 = eva;
        % new unit
        freq_pi0 = freq_pi;
        eva_pi0 = eva_pi;
        freq_m0 = freq_m;
        eva_m0 = eva_m;
        eva_2_0 = eva_2;
        no_change = 0;
    else
        pi(x)=A;
%         disp('no_change');
%         disp(no_change);
        no_change = no_change + 1;
    end
end
end