# https://github.com/hetong007/CategoricalClustering

# Hash Function for duplication detection
hash = function(x)
{
    calc = function(a,b)
        (a*1009+b) %% 1000000009
    Reduce(calc,x)
}

# Get the list of possible values for each attribute
attriList = function(mat)
{
    ans = apply(mat,2,function(x) sort(unique(x)))
    ans
}

# Extend the neighbour from the original data
extension = function(mat,attri_list)
{
    ans = list()
    l = 1
    for (i in 1:nrow(mat))
        for (j in 1:ncol(mat))
        {
            for (k in attri_list[[j]])
            {
                if (mat[i,j]!=k)
                {
                    ans[[l]] = mat[i,]
                    # ans[[l]][j] = 1-ans[[l]][j]
                    ans[[l]][j] = k
                    l = l+1
                }
            }
        }
    ans = do.call(rbind,ans)
    ans = rbind(mat,ans)
    # Calculate hashVal for each value
    hashVal = apply(ans,1,hash)
    # No further examination here
    ind = which(!duplicated(hashVal))
    ans = ans[ind,]
    ans
}

# Calculate Hamming Distance between a center and a list of samples
HammingDistance = function(S,mat)
{
    ans = S!=t(mat)
    ans = colSums(ans)
    ans
}

# Calculate the U(S) defined in the paper
UofS = function(S,mat)
{
    Dist = HammingDistance(S,mat)
    ans = tabulate(Dist,ncol(mat))
    ans = c(sum(Dist==0),ans)
    ans
}

# Uniform Distribution
UniformHD = function(attri_size,row_no)
{
    n = attri_size - 1
    p = length(n)
    uni_size = rep(1,p)
    w = rep(1,p)
    s = rep(1,p)
    for (i in 1:p)
    {
        for (j in i:p)
        {
            if (j == 1)
                w[1] = n[1]
            else
                w[j] = n[j]*s[j-1] + w[j-1]
        }
        uni_size[i] = w[p]
        s = w
        w = rep(0,p)
    }
    uni_distribution = c(1,uni_size)
    uni_distribution = uni_distribution * row_no / prod(attri_size)
    uni_distribution
}

# ??
# calculate the modified chisq statistic for each center candidate
choose.r.M = function(p,US,UHD)
{
    chi1 = 0
    chi2 = 0
    chi3 = 0

    cnn = which(US[-1]<UHD[-1])
    if (length(cnn)==0)
        cnn = 1
    else
        cnn = cnn[1]-1
    if (cnn==0)
        chi = 0
    else
    {
        if (cnn>1)
            chi3 = chi3 + sum((US[1:(cnn-1)]-UHD[1:(cnn-1)])^2/UHD[1:(cnn-1)])
        chi3 = chi3 + 
            (sum(US[1:(cnn-1)])-sum(UHD[1:(cnn-1)]))^2/sum(UHD[-(1:(cnn-1))])
        chi2 = chi2 + sum((US[1:cnn]-UHD[1:cnn])^2/UHD[1:cnn])
        chi1 = chi2
        chi2 = chi2 + (sum(US[1:cnn])-sum(UHD[1:cnn]))^2/sum(UHD[-(1:cnn)])
        chi1 = chi1 + (US[cnn+1]-UHD[cnn+1])^2/UHD[cnn+1]
        chi1 = chi1 + 
            (sum(US[1:(cnn+1)])-sum(UHD[1:(cnn+1)]))^2/sum(UHD[-(1:(cnn+1))])
        if (cnn==1)
            p3 = 0
        else
            p3 = dchisq(chi3,cnn-1)
        
        res = c(dchisq(chi2,cnn),dchisq(chi1,cnn+1),p3)
        ans = c(chi2,chi1,chi3)
        ind = which.max(res)
        chi = ans[ind]
    }
    return(chi)
}

# Calculate the radius according to the paper
Radius = function(C,mat)
{
    p = ncol(mat)
    UC = UofS(C,mat)
    ans = UC[2:p]<UC[1:(p-1)] & UC[2:p]<UC[3:(p+1)]
    if (sum(ans)==0)
        ans = 0
    else
        ans = which(ans)[1]
    ans
}

# Main function for this algorithm
CategorialCluster = function(mat)
{
    clusters = list()
    centers = list()
    sampleInd = 1:nrow(mat)
    numOfClusters = 1
    ori = mat
    
    attri_list = attriList(mat)
    Set = extension(mat,attri_list)
    p = ncol(mat)
    attri_size = sapply(attri_list,length)
    UHD = UniformHD(attri_size,nrow(mat))
    
    # What is the indicator??
    indicator = 1
    ending = FALSE
    while (!ending)
    {
        maxStat = 0
        C = NULL
        # Loop through every possible S
        for (ind in 1:nrow(Set))
        {
            S = Set[ind,]
            US = UofS(S,mat)
            tmp = choose.r.M(p,US,UHD)
            if (tmp[1]>maxStat)
            {
                maxStat = tmp[1]
                C = S
            }
        }
        # If no significant left
        if (maxStat<qchisq(0.95,p))
        {
            ending = TRUE
        }
        else
        {
            # Calculate the radius, with some modification from the paper
            if (indicator==1)
            {
                rad0 = Radius(C,mat)
                rad = rad0
            }
            else
            {
                UC = UofS(C,mat)
                if (UC[rad0]>=UC[rad0+1])
                    rad = rad0
                else if (UC[rad0-1]-UC[rad0] >= 2)
                    rad = rad0-1
                else
                    rad = rad0
            }
            
            dis = HammingDistance(C,mat)
            ind = which(dis<=rad)
            if (length(ind)>0)
            {
                clusters[[numOfClusters]] = sampleInd[ind]
                centers[[numOfClusters]] = C
                numOfClusters = numOfClusters+1
                mat = mat[-ind,,drop=FALSE]
                sampleInd = sampleInd[-ind]
                if (nrow(mat)==0)
                    ending = TRUE
            }
            else
                ending = TRUE
            
            # Delete the neighbours in the radius as well
            dis = HammingDistance(C,Set)
            ind = which(dis<=rad)
            if (length(ind)>0)
                Set = Set[-ind,,drop=FALSE]
        }
        indicator = indicator+1
    }
    Dist = list()
    for (i in 1:length(centers))
        Dist[[i]] = HammingDistance(centers[[i]],ori)
    Dist = do.call(cbind,Dist)
    # Find the nearest center
    clusters = max.col(-Dist)
    list(clusters,centers)
}

