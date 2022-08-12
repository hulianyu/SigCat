ccdv.m is the main program. It takes data sets as the only input. The data set is required to be numerical values only and the last column is the true cluster number which is used to calculate the clustering results. It can be easily modified if you do not have the true cluster values and you just want to obtain the clustering results by this method. Each row of the data set represents an observation with m many attributes.
There are five outputs. They are clustering correctness rate, the resultant cluster centers, the resultant cluster values for the data set, total information gain, and proportional information gain of this clustering in a sequence. The usage is "[a b c d e]=ccdv(data)" where a, b, c, d, e are the variables you want to store the results above-mentioned and data is the raw data set.
Other programs are supplemental ones. 
dist_cate is to calculate the distance between two categorical data points;
expend is used to obtain the neighboring positions of a data point;
get_cd is used to get the CD vector of  a data point;
get_chi is to calculate the modified Chi-squared value;
get_uni is used to get the uniform CDV;
simu is the function for simulation.