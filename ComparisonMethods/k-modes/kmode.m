function obs_cluster = kmode(data, k)
m = size(data,2);
n = size(data,1);
data(:,end+1) = 0;
mode = data(1:k,1:m) ;
while 1
    indicator = 1;
    for i = 1:n
%         d = [];
        d = zeros(1,k);
        for j = 1:k
%             d = [d dist_cate(data(i,1:m), mode(j,1:m))];
            d(1,j) = dist_cate(data(i,1:m), mode(j,1:m));
        end
        [~, ind] = min(d);
        indicator = indicator & (ind == data(i,end));
        data(i, end) = ind;
        cluster = data(data(:,end) == ind, :);
        mode(ind,:) = get_mode0(cluster(:,1:m));
    end
    if indicator == 1
        break;
    end
end
obs_cluster = data(:,end);