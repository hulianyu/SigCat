function B = BK(R)
% Chen K, Liu L. “Best K”: critical clustering structures in categorical datasets[J]. KIS, 2009.
% critical knees(second-order difference) on the I(K): B(K) = (I(K-1)- I(K))-(I(K)- I(K+1))  
% difference between the neighboring: I(K) = R(K)-R(K+1)
K = length(R);
I = R(1:K-1) - R(2:K);
B = I(1:K-3)-2*I(2:K-2)+I(3:K-1);
end