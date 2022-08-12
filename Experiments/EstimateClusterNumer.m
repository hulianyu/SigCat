clearvars
addpath([cd '/']);
addpath([cd '/Datasets']);
filename = char('lenses','soybean-small','lung-cancer','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','breast-cancer-wisconsin','tic-tac-toe','car','chess',...
    'mushroom','nursery');
maxK = 10;
ET = 50;
estK = zeros(19,5);  % Estimate Cluster Numer [GT,mode(mGap),mean(mGap),BIC,BKPlot]
SRS_X = zeros(19,9); % SRS value of each locally optimal partition
%% mGap
mGap_RunningTimes = cell(19,ET);
mGap_estK = zeros(19,ET); % estimated k by using mGap
mGap_values = cell(19,ET);
SRS_rX = cell(19,ET); % SRS value of ET sets of reference partitions
%% others
BIC_values = zeros(19,maxK-1);% BIC
BKPlot_values = zeros(19,maxK-4);% BKPlot
%% Choose a data set I
for I=1:2
    disp('Data:');disp(strtrim(filename(I,:)));
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Dataset
    estK(I,1) = length(unique(X_data(:,1))); %Ground Truth Cluster Number
    %% calculate the SRS value of each locally optimal partition with varied k=2:maxK on X 
    NUM = 20; 
    for k=2:maxK
        [eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2] = SRS_init(X,k);
        parfor runs = 1:NUM
            [eva_tmp(1,runs),~] = minMC_SRS(X,k,eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2);
        end
        eva_tmp(1,:) = sort(eva_tmp(1,:));
        SRS_X(I,k-1) = eva_tmp(1,floor(NUM/2));
    end
    w_data = SRS_X(I,:);
    %% Determine the number of categorical clusters by using mGap
    disp('mGap');
    parfor runs=1:ET
        disp(runs/ET);
        [~,SRS_rX{I,runs},mGap_RunningTimes{I,runs}] = SRS_randomizedX(X,maxK);
        [mGap_estK(I,runs),mGap_values{I,runs}]= mGap(SRS_rX{I,runs},w_data,maxK);
    end
    estK(I,2) = mode(mGap_estK(I,:));
    estK(I,3) = mean(mGap_estK(I,:));
    %% Determine the number of categorical clusters by using BIC and BKPlot
    addpath([cd '/ComparisonMethods/EstimateK']);
    % BIC \min
    disp('BIC');
    BIC_values(I,:) = BIC(w_data,X);
    [~,BIC_estK] = min(BIC_values(I,:));
    estK(I,4) = BIC_estK+1;
    % BKPlot \max
    disp('BKPlot');
    BKPlot_values(I,:) = BK(w_data);
    [~,BKPlot_estK] = max(BKPlot_values(I,:));
    estK(I,5) = BKPlot_estK+1;
    save('_EstimateClusterNumer.mat','estK','SRS_X','SRS_rX','mGap_RunningTimes','mGap_estK','mGap_values','mGap_estK',...
        'BIC_values','BKPlot_values');
end

%% used functions
function [Xr,SRS_r,TimeK] = SRS_randomizedX(X,maxK)
%  calculate SRS values of a locally optimal partition with varied k=2:maxK on randomized X 
%% set the number of random data sets, maxK
NUM = 20; % 20datasets*1times
R = zeros(NUM,1);
SRS_r = zeros(NUM,maxK-1);
Xr = cell(NUM,1);
TimeK = zeros(1,maxK-1);
parfor r=1:NUM
    Xr{r,1} = G_swap(X);
end
for k=2:maxK
    % initialization of pi
    % a = ['generate:',num2str((num/(NUM))*100),'%'];
    % disp(a);
    tic
    [eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2] = SRS_init(X,k);
    parfor num=1:NUM
        [R(num,1),~] = minMC_SRS(Xr{num,1},k,eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2);
    end
    TimeK(1,k-1) = toc;
    SRS_r(:,k-1) = R;
end
end
function X_random = G_swap(X)
% Generate random dataset X_random from exact Multinomial Distribution
% swap(a,b)
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