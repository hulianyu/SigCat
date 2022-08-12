
clear;
clc;

% input data name
load BC; % possible inputs in this demo package: AE, BC, HR, LG, LS, NS 
X=BC; 
% input the number of ordinal attributes in the above data set
ordinal_num=4; % corresponding to the above input data set. possible inputs: AE:2, BC:4, HR:2, LG:3, LS:2, NS:7
% input experimental settings
% T=50;
% obtain the data statistics and execute the experiment

XLable=X(:,end);
K=max(XLable);
X=X(:,1:end-1);
pi = HD_NDW_Clustering(X,K,ordinal_num);
disp('Performance of HD-NDW:');
CI = ClusteringMeasure(XLable, pi);