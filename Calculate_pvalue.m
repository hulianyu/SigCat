function [R,p] = Calculate_pvalue(X,K,eva)
% calculating an empirical p-value
%% set the number of random data sets
NUM = 5000; % 1000datasets*50times
N = 100;
T = 50;
p = zeros(T,1);
%% initialization of pi
[eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2] = SRS_init(X,K);
%%
R = zeros(NUM,1);
parfor num=1:NUM
    a = ['generate:',num2str((num/(NUM))*100),'%'];
    disp(a);
    X_random = G_swap(X);
    [R(num,1),~] = minMC_SRS(X_random,K,eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2);
end
for t=1:T
    R_t = R(N*(t-1)+1:N*t,1);
    p(t,1) = sum(le(R_t,eva))/N;
end
end


function X_random = G_swap(X)
% Generate a randomized data set: swap(a,b)
N = size(X,1);
M = size(X,2);
X_random = X;
for i=1:M
    G = 1:N;
    a = randperm(N,1);
    A = X(a,i);
    rn1 = X(:,i)==A;
    G(rn1) = [];
    B = randperm(length(G),1);
    b = G(B);
    X_random(a,i) =  X(b,i);
    X_random(b,i) = A;
end
end