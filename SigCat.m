function [EVA,PI,eva,pi] = SigCat(X,K)
RT = 20;
%% initialization of pi
[eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2] = SRS_init(X,K);
%% execute RT times
parfor runs = 1:RT
    [eva,pi] = minMC_SRS(X,K,eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2);
    EVA(:,runs) = eva;
    PI(:,runs) = pi;
end
[eva,select] = min(EVA);
pi = PI(:,select);
end