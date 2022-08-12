function cluster_all = ccdv(data)
% purpose: the main program of the project. It implement a new algorithm for clustering
%          categorical data. It mainly comprises manipulation of the original data, which
%          is done by function expend.m.
% record of revisions:
%     date               programmer              description of change
% -----------        -----------------          ------------------------
% June 11,2003        Peng Zhang                 Original code
%
% define variables:
% M(2)        -- the length of the row of the data
% M(1)        -- number of points in the data set
% prototype   -- a cell array to store the values of each attribute
% working     -- returned working data
M = size(data);
attri_size = zeros(1, M(2));
prototype = cell(1, M(2));
for i = 1: M(2)
    prototype{i} = unique(data(:,i));
    attri_size(i) = length(prototype{i});
end
% sort data according to first column make it unique and find the number of each row and append to each row.
data_sort = sortrows(data);
diff_array = data_sort(1:end-1,:) - data_sort(2:end,:);
repeat_index = [];
for i = 1:M(1)-1
    equal_status = 0;
    for j = 1:M(2)
        equal_status = equal_status + (diff_array(i,j) ~= 0);
    end
    if equal_status ~= 0
        repeat_index = [repeat_index i];
    end
end
repeat_index = [repeat_index M(1)];
unique_index = diff([0 repeat_index]);
data_uni = unique(data_sort,'rows');
data_with_frequency = [data_uni unique_index'];
% calculate the testing statistic and look for the point which has the biggest value
if length(data_uni(:,1))/prod(attri_size) <  1
    add = expend(data);
    data_and_add = [data_with_frequency;add];
else
    data_and_add = data_with_frequency;
end

m = length(data_uni(1,:));
n = length(data_and_add(:,1));
cn = M(2);
working = [data_and_add zeros(n,cn+2)];
% generate the required 'uniform' distribution
uni = get_uni(attri_size,M(1));
cluster = 1;
cluster_center = [];
indicator = 1;
while 1
    sw = size(working);
    for i = 1:sw(1)
        for j = 1: length(data_with_frequency(:,1))
            d = dist_cate(working(i,1:m), data_with_frequency(j,1:m));
            for k = 1:cn
                if d == k
                    working(i,M(2)+k+1) = working(i,M(2)+k+1) + data_with_frequency(j,M(2)+1);
                    break;
                end
            end
        end
    end
    
    mmind = zeros(sw(1),1);
    for i = 1:sw(1)
        [chi, mind] = get_chi(working(i,:),M(2),M(1),cn,uni);
        working(i,m+cn+1) = chi;
        mmind(i,1) = mind;
    end
    [max_chi, max_ind] = max(working(:,m+cn+1));
    if max_chi == 0
        break;
    end
    center = working(max_ind,1:m+1);
    centercd = working(max_ind,m+1:m+cn)';
    if indicator == 1
        for i = 2:cn-1
            if centercd(i) < centercd(i - 1) && centercd(i) < centercd(i + 1)
                radius0 = i - 1;
                break;
            end
        end
        radius = radius0;
    elseif centercd(radius0) >= centercd(radius0+1)
        radius = radius0;
    elseif (centercd(radius0 - 1) - centercd(radius0)) >= 2
        radius = radius0 -1;
    else
        radius = radius0;
    end
    center(m+2) = cluster;
    if max_chi >= chi2inv(.95,m)
        % determine the radius of this cluster
        for ii = 1:sw(1)
            if dist_cate(center(1:m),working(ii,1:m)) <= radius
                working(ii,m+cn+2) = cluster;
            else
                working(ii,m+cn+2) = 0;
            end
        end
    else
        break;
    end
    real_size = size(data_with_frequency);
    cluster = cluster + 1;
    cluster_center = [cluster_center;center];
    clu_index1 = find(working(1:real_size(1),m+cn+2));
    clu_index = find(working(1:sw(1),m+cn+2));
    working(clu_index,:) = [];
    data_with_frequency(clu_index1,:) = [];
    working(:,m+2:end) = 0;
    indicator = indicator + 1;
end
for i = 1:length(data(:,1))
    dd = zeros(1,length(cluster_center(:,1)));
    for j = 1:length(cluster_center(:,1))
        dd(1,j) = dist_cate(data(i,1:m),cluster_center(j,1:m));
%         dd = [dd dist_cate(data(i,1:m),cluster_center(j,1:m))];
    end
    [~, min_index] = min(dd);
    data(i,m+1) = cluster_center(min_index,end);
end
cluster_all = data(:,end);