clearvars
addpath([cd '/']);
%% 19 UCI data sets
addpath([cd '/Datasets']);
filename = char('lenses','soybean-small','lung-cancer','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','breast-cancer-wisconsin','tic-tac-toe','car','chess',...
    'mushroom','nursery');
IS = size(filename,1);
RunningTimes = zeros(IS,6); % seconds (for each clustering algorithm)
%% Load Evaluation package
addpath([cd '/Evaluation']); % 7 metrics [ACC, NMI, Purity, ARI, Precision, Recall, F-score]
%% set execute times (for each clustering algorithm)
ET = 50;
%% Our method
% [1] K-SigCat
addpath([cd '/SCAT']);
Pi_SigCat = cell(IS,1); % a locally optimal partition
Metric_SigCat = zeros(IS,7); % performance metrics
%% Comparison methods: k-modes, Entropy, DV, CMS, HD-NDW
% [2] k-modes
addpath([cd '/ComparisonMethods/k-modes']);
Pi_kmodes = cell(IS,1);
Metric_kmodes = zeros(IS,7);
% [3] Entropy
addpath([cd '/ComparisonMethods/Entropy']);
Pi_Entropy = cell(IS,1);
Metric_Entropy = zeros(IS,7);
% [4] DV
addpath([cd '/ComparisonMethods/DV']);
Pi_DV = cell(IS,1);
Metric_DV = zeros(IS,7);
DV_k = zeros(IS,1); % Detect k clusters
% [5] CMS
addpath([cd '/ComparisonMethods/CMS']);
addpath([cd '/ComparisonMethods/CMS/Ncut']); % NcutClustering
Pi_CMS = cell(IS,1);
Metric_CMS = zeros(IS,7);
% [6] HD-NDW
addpath([cd '/ComparisonMethods/HD-NDW']);
Pi_HDNDW = cell(IS,1);
Metric_HDNDW = zeros(IS,7);

%% Choose a data set I
for I=1:4
    disp("Datasets:");disp(strtrim(filename(I,:)));
    %% information from selected data set
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Data set
    X_Label = X_data(:,1); %Ground Truth
    M = size(X,2); %Attribute Number
    K = length(unique(X_Label)); %Cluster Number
    %% Performance
    %% [1] SigCat
    disp("SigCat");
    % initialization of pi
    Pi = zeros(size(X,1),ET);
    tic
    [eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2] = SRS_init(X,K);
    for runs = 1:ET
        [~,pi_runs] = minMC_SRS(X,K,eva0,freq_pi0,eva_pi0,freq_m0,eva_m0,eva0_2);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,1) = toc;
    Pi_SigCat{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_SigCat(I,:) = Metric_SigCat(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_SigCat(I,:) = Metric_SigCat(I,:)./ET;
    %% [2] k-modes
    disp("k-modes");
    Pi = zeros(size(X,1),ET);
    tic
    for runs = 1:ET
        pi_runs = kmode(X, K);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,2) = toc;
    Pi_kmodes{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_kmodes(I,:) = Metric_kmodes(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_kmodes(I,:) = Metric_kmodes(I,:)./ET;
    %% [3] Entropy
    disp("Entropy");
    % initialization of pi
    Pi = zeros(size(X,1),ET);
    tic
    [eva0,freq_pi0,freq_m0,eva_m0,eva_2_0] = EE_init(X,K);
    for runs = 1:ET
        [~,pi_runs] = minMC_EE(X,K,eva0,freq_pi0,freq_m0,eva_m0,eva_2_0);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,4) = toc;
    Pi_Entropy{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_Entropy(I,:) = Metric_Entropy(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_Entropy(I,:) = Metric_Entropy(I,:)./ET;
    %% [4] DV
    disp("DV");
    tic
    try
        Pi = ccdv(X);
    catch
        Pi = 0; % fail to detect clusters
    end
    RunningTimes(I,3) = toc*ET;
    if Pi~=0
        Pi_DV{I,1} = Pi;
        % evaluate the metrics
        Metric_DV(I,:) = ClusteringMeasure(X_Label, Pi);
    else
        Metric_DV(I,:) = 0;
    end
    DV_k(I,1) = max(Pi);
    %% [5] CMS
    disp("CMS");
    Pi = zeros(size(X,1),ET);
    tic
    for runs = 1:ET
        pi_runs = CMS(X,K);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,5) = toc;
    Pi_CMS{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_CMS(I,:) = Metric_CMS(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_CMS(I,:) = Metric_CMS(I,:)./ET;
    %% [6] HD-NDW
    disp("HD-NDW");
    Pi = zeros(size(X,1),ET);
    tic
%     ordinal_num = floor(M/2);% half of all
    ordinal_num = 0;
    for runs = 1:ET
        pi_runs = HD_NDW_Clustering(X,K,ordinal_num);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,6) = toc;
    Pi_HDNDW{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_HDNDW(I,:) = Metric_HDNDW(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_HDNDW(I,:) = Metric_HDNDW(I,:)./ET;
    %% Save the results
    save('_PerformanceComparison.mat','RunningTimes','ET','Pi_SigCat','Metric_SigCat','Pi_kmodes','Metric_kmodes',...
        'Pi_Entropy','Metric_Entropy','Pi_DV','Metric_DV','DV_k',...
        'Pi_CMS','Metric_CMS','Pi_HDNDW','Metric_HDNDW');
end