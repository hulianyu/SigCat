function B = BIC(R,X)
% BIC = 2*R + (k*MQ)*log(M*N)
N = size(X,1);
M = size(X,2);
list_sample = countcats(categorical(X(:,1:M)));
list_sample = list_sample(:);
list_sample(list_sample==0)=[];
MQ = length(list_sample);
B = zeros(1,length(R));
for k=2:length(R)+1
    th = k-1;
    B(th) = 2*R(th) + (k*MQ)*log(M*N);
    disp(B(th))
end
end