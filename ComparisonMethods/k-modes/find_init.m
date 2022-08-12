function pi_init = find_init(X,K)
N = size(X,1);
a = 1:N;
init = a(randperm(length(a)));
init = init(1:K);
initK = zeros(N,K);
% computing similarity using hamming distance
for it=1:K
    for i=1:N
        initK(i,it) = dist_cate(X(init(it),:),X(i,:));
    end
end
[~,b] = sort(initK,2);
pi_init = b(:,1);
end