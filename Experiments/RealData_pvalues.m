% clearvars
addpath([cd '/']);
%% load 19 data sets
addpath([cd '/Datasets']);
load('LocallyOptimalPartition.mat')
filename = char('lenses','soybean-small','lung-cancer','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','breast-cancer-wisconsin','tic-tac-toe','car','chess',...
    'mushroom','nursery');
SRS_X = zeros(19,1);
r_pvalues = cell(19,1);
SRS_randomizedX = cell(19,1);
ET = 50;
eva = zeros(19,ET);
RealData_pvalue_RunningTimes = zeros(19,1);
%% Choose a data set I
for I=1:2
    disp("Datasets:");disp(strtrim(filename(I,:)));
    %% information from selected data set
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Dataset
    X_Label = X_data(:,1); %Ground Truth
    M = size(X,2);
    K = length(unique(X_Label)); %Cluster Number
    %% calculate the SRS value of a locally optimal partition
    for runs=1:ET
        eva(I,runs) = SRS(X,Pi_SigCat{I,1}(:,runs));
    end
    eva(I,:) = sort(eva(I,:));
    eva_m = eva(I,25);
    SRS_X(I,1) = eva_m;
    %% calculate an empirical p-value
    tic
    [SRS_randomizedX{I,1},r_pvalues{I,1}] = Calculate_pvalue(X,K,SRS_X(I,1));
    RealData_pvalue_RunningTimes(I,1) = toc;
    %% Save the results
    save('_RealData_pvalues.mat','SRS_X','r_pvalues','SRS_randomizedX','RealData_pvalue_RunningTimes');
end