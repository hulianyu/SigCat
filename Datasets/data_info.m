clearvars
addpath([cd '/Datasets']);
%% load data sets
filename = char('lenses','soybean-small','lung-cancer','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','breast-cancer-wisconsin','tic-tac-toe','car','chess',...
    'mushroom','nursery');
IS = size(filename,1);
%%
info = zeros(11,4); % N, M, Q, K
for I=1:IS
    disp("I");disp(I);
    %% information from selected data set
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Dataset
    X_Label = X_data(:,1); %Ground Truth
    info(I,1) = size(X,1);
    info(I,2) = size(X,2);
    Q = 0;
    for m=1:info(I,2)
        max_att = max(X(:,m));
        Q = Q+max_att;
    end
    info(I,3) = Q;
    info(I,4) = length(unique(X_Label)); %Cluster Number
end
save('DataInfo.mat','filename','info')