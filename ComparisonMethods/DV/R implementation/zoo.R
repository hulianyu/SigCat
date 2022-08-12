source('cluster.R')

# Load Zoo Data
mat = read.csv('../data/zoo.txt',header=FALSE)
nms = mat[,1]
groundTruth = mat[,ncol(mat)]
mat = mat[,-c(1,ncol(mat))]
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
