function [ data, center, dat] = simu(states)
% Script file simu.m
% purpose: to simulate a categorical data given the state value of each
%          attribute. It firstly generate randomly the cluster centers. The
%          number of clusters is specified by clusterno. It then generate ni
%          many random numbers of vectors of standard normal and determine 
%          the value of each attribute by discretization and randomization.
% record of revisions:
%     date               programmer              description of change
% -----------        -----------------          ------------------------
% Nov 10,2003        Peng Zhang                 Original code
% 
% define variables:
% true      --  true cluster labels
% cluster   --  resultant cluster label obtained by the algorithm
% rlen      --  run length of true cluster
% states=[5 3 4 5 3 5 3 5 6 4];
m = length(states);   % dimension
n = [70 50 40 25 15];    % numbers of data in each cluster, can be changed later
% generate cluster centers
center = [];
center(1,:) = round(rand(1,m) .* (states - 1));
for i = 2:length(n)
    while 1
        temcenter = round(rand(1,m) .* (states - 1));
        dis = [];
        for j = 1:i-1
            dis(j) = dist_cate(center(j,:),temcenter);
        end
        if min(dis) <= m/2
            continue;
        end
        break;
    end
    center(i,:) = temcenter;
end
%center
% generate data
data = [];
for i = 1:length(n)
    centercom = setdiff(center,center(i,:),'rows');
    data=[data;[center(i,:) i]];
    temp = randn(n(i)-1,m);
    for j = 1:n(i)-1
        for k = 1:m
            if abs(temp(j,k)) < norminv(.85,0,1)   % 70% quantile
                temp(j,k) = center(i,k);
            else
                cand = setdiff((1:states(k))-1, center(i,k));
                poss = randperm(states(k)-1);
                pos = poss(1);
                temp(j,k) = cand(pos);
            end
        end
        temdis = [];
        for ii = 1:length(centercom(:,1))
            temdis(ii) = dist_cate(centercom(ii,:),temp(j,:));
        end
        if min(temdis) > m/3
            tem = [temp(j,:) i];
            data = [data;tem];
        else
            data=[data;[center(i,:) i]];
        end
    end
end

dat=[(1:length(data(:,1)))' data(:,end) data(:,1:end-1)];