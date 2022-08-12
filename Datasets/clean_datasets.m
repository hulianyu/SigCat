% clean data sets from UCI (.data)
% eg. Mushroom Data Set
clearvars
addpath([cd '/Datasets']);
%% load datasets with format '.data' or '.txt'
% agaricuslepiota = readtable('agaricus-lepiota.txt','ReadVariableNames',false);
% or load .data from MATLAB tool
%% save labels and attributes with no. category 
cats = categorical(agaricuslepiota{:,1}); % labels position: 1st or end
cats = double(cats);
agaricuslepiota(:,12) = []; % the missing values belong only to the (stalk_root) variable
% delete a variable or simply treat missing values (denoted as “?”) as a new categorical value.
X = zeros(8124,21);
for i=1:21
    cc = categorical(agaricuslepiota{:,i+1});
    X(:,i)=  double(cc);
end
%% delete attributes which only have one category.
onec = [];
for i=1:21
    if length(unique(X(:,i)))==1
        onec = [onec i];
    end
end
%% add the labels to the 1st attribute in the dataset
X(:,onec)=[];
X = [cats X];
%% save datasets as .txt
writematrix(X,'agaricus-lepiota.txt','delimiter',',');
%% usage
filename = char('lenses','soybean-small','lung-cancer','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','breast-cancer-wisconsin','tic-tac-toe','car','chess',...
    'mushroom','nursery');
I = 18;
X_data = load([strtrim(filename(I,:)), '.txt']); %load a dataset
X = X_data(:,2:end);
X_Label = X_data(:,1);%Ground truth