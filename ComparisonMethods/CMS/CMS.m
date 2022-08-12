function pi = CMS(X,K)
N = size(X,1);
M = size(X,2);
X_u = trans2unique(X);
elements = zeros(M,1);
Mat = zeros(N,N);
a = 0.5; % the default value is 0.5
[~, ~, s]=CMS_similarity(X_u,a);
for i=1:N
    for j=1:N
        for m=1:M
            elements(m,1) = s(X_u(i,m),X_u(j,m));
        end
        e = sum(elements)/M;
        Mat(i,j)=e;
    end
end
[pi,~] = NcutClustering(Mat,K);
end

function X_u = trans2unique(X)
M = size(X,2);
X_u = X;
Q = max(X(:,1:M));
for m=2:M
    Qm = sum(Q(1:m-1));
    X_u(:,m) = X(:,m) + Qm;
end
end