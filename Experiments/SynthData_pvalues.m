% clearvars
addpath([cd '/']);
%% load 19 data sets
addpath([cd '/Datasets']);
filename = char('lenses','soybean-small','lung-cancer','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','breast-cancer-wisconsin','tic-tac-toe','car','chess',...
    'mushroom','nursery');
SRS_Xs = zeros(19,1);
s_pvalues = cell(19,1);
SRS_randomizedXs = cell(19,1);
ET = 50;
eva = zeros(19,ET);
SynthData_pvalue_RunningTimes = zeros(19,1);
X_s = cell(19,1); % completely randomized X
%% Choose a data set I
for I=1:2
    disp("Datasets:");disp(strtrim(filename(I,:)));
    %% information from selected data set
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Dataset
    X_Label = X_data(:,1); %Ground Truth
    M = size(X,2);
    K = length(unique(X_Label)); %Cluster Number
    %% randperm: generate a completely randomized data set
    X = G_randperm(X);
    X_s{I,1} = X;
    %% SigCat
    Pi = zeros(size(X,1),ET); % to obtain the SRS value of a locally optiaml partition on X_s 
    [eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2] = SRS_init(X,K);
    for runs = 1:ET
        disp(runs);
        [eva(I,runs),~] = minMC_SRS(X,K,eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2);
    end
    eva(I,:) = sort(eva(I,:));
    eva_m = eva(I,25);
    SRS_Xs(I,1) = eva_m;
    %% calculate an empirical p-value
    tic
    [SRS_randomizedXs{I,1},s_pvalues{I,1}] = Calculate_pvalue(X,K,SRS_Xs(I,1));
    SynthData_pvalue_RunningTimes(I,1) = toc;
    %% Save the results
    save('_SynthData_pvalues.mat','s_pvalues','SRS_randomizedXs');
end

function X_random = G_randperm(X)
% Generate a completely randomized data set: randperm(N)
N = size(X,1);
M = size(X,2);
X_random = zeros(N,M);
for i=1:M
    X_random(:,i) = X(randperm(N),i);
end
end