source('cluster.R')

# no significant clusters(cluster centers): balance-scale, car, nursery, primary-tumor
# Load lymphography Data
# mat = read.csv('../data/lymphography.txt',header=FALSE)
# Load house-votes Data
mat = read.csv('../data/house-votes-84.txt',header=FALSE)
groundTruth = mat[,1]
mat = mat[,-1]
mat = as.matrix(mat)

# Run Clustering
ans = CategorialCluster(mat)

# Result Analysis
tb = table(ans[[1]],groundTruth)
rename = NULL
for (i in unique(groundTruth))
{
  tmp = order(tb[,i],decreasing=TRUE)
  rename[i] = setdiff(tmp,rename)[1]
}

corr = sum(diag(tb[rename,]))
corr/sum(tb)
