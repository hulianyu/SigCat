function [eva0,pi] = minMC_EE(Xm,K,eva0,freq_pi0,freq_mk0,eva_mk0,eva_2_0)
% Minimize EE
% A Monte-Carlo method accepts any better solutions instead of performing systematic searches.
% Li T, Ma S, Ogihara M. Entropy-based criterion in categorical clustering. ICML. 2004.

N = size(Xm,1);
pi0 = ones(N,1);
pi = pi0;
update_no = 0;
freq_pi0(2:K,1) = 0;
max_Repeat = (K-1)*N;
while update_no<=max_Repeat
    % Randomly pick a point x form A
    x = randperm(N,1);
    A = pi(x);
    % Randomly pick another cluster B
    setB = setdiff(1:K, A);
    B = setB(randperm(numel(setB),1));
    % Put x into B
    pi(x)=B;
    % Compute the SRS
    X = Xm(x,:);
    [eva,freq_pi,freq_mk,eva_mk,eva_2] = EE_update(freq_pi0,freq_mk0,eva_mk0,eva_2_0,X,A,B);
    % Compare the result
    if eva<eva0
        eva0 = eva;
        % new unit
        freq_pi0 = freq_pi;
        freq_mk0 = freq_mk;
        eva_mk0 = eva_mk;
        eva_2_0 = eva_2;
        update_no = 0;

    else
        pi(x)=A;
        update_no = update_no + 1;
    end
end
end