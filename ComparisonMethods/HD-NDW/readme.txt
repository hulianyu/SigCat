
_______________________________________________________General Information___________________________________________________________

This folder provdes the MATLAB code of the paper entitled "Learnable Weighting of Intra-Attribute Distances for Categorical Data Clustering with Nominal and Ordinal Attributes" (called "this paper" hereinafter)
by Yiqun Zhang and Yiu-ming Cheung, IEEE Transactions on Pattern Analysis and Machine Intelligence, 2021, DOI:10.1109/TPAMI.2021.3056510.

If you have any enquiries, please contact Dr. Yiqun Zhang or Prof. Yiu-ming Cheung via email: yqzhang@gdut.edu.cn, ymc@comp.hkbu.edu.hk.

_________________________________________________________File Information______________________________________________________________

All the files in this folder are introduced below:
- Ex_Execution.m:       A script to execute the proposed HD-NDW on a data set.
- HD_NDW_Clustering.m:  Main function that iteratively learns the partition and weights using the proposed HD-NDW.
- HD_Dist.m:            A function that uses the proposed HD metric to compute intra-attribute distances of a data set.
- BC.mat, HR.mat, LG.mat, LS.mat, NS.mat:
                        Data sets for demo. BC, HR, LG, LS, NS are the Cancer, Hayes, Lym, Lenses, Nursery data sets appeared in the experiments of this paper, which are mixed data sets collected from the UCI machine learning repository (http://archive.ics.uci.edu/ml/index.php).
- AE.mat,  PE.mat:      The two questionnaire data sets, i.e., Assistant and Photo appeared in the experiments of this paper. Since Photo is a monotonic ordinal data set, it should be treated according to the instructions provided in Section 6.1.4 of this paper. 
- Eva_ARI.m:            A function obtained from the MathWorks File Exchange for evaluating the clustering performance in terms of adjusted rand index.
- readme.txt:           This file.

_______________________________________________________Execution Information______________________________________________________________

To obtain the experimental results using the code here, please follow the three steps below:
1. Input file name of the target data set in Ex_Execution.m, e.g., BC as the default in the provided code.
2. Input the number of ordinal attributes of the target data set in Ex_Execution.m, e.g., 4 of BC as the default in the provided code.
3. Run Ex_Execution.m file, then the experimental result will be displayed automatically.

Please note that this paper assumes that the former part of the attributes of a data set are ordinal attributes and the latter part are nominal attributes (see Section 3 of this paper), and necessary pre-processing has been performed to the raw data sets for experimental convenience.
All the data sets provided in this package have been pre-processed by converting their original non-numerical values into numerical values for storage convenience.
The numerical values of nominal attributes are just used to distinguish the corresponding original values, and will not participate in any mathematical computation. The numerical values of ordinal attributes simultaneously indicate the corresponding original values and their relative orders. Please note that we do not distinguish descending order and ascending order of ordinal attribute values because they have no effect on our proposed method.
Please also note that when using the code here to process a data set other than the demo data sets provided here, it may be necessary to pre-process the data set, and make sure to follow the data set composition assumption in Section 3 and the instruction in Section 6.1.4 of this paper.

_________________________________________________________Citation Information__________________________________________________________

Please cite the paper if the codes are helpful for you research. Citation information is provided below for the convenience of readers.

General citation: 
Yiqun Zhang and Yiu-ming Cheung, “Learnable Weighting of Intra-attribute Distances for Categorical Data Clustering with Nominal and Ordinal Attributes”, IEEE Transactions on Pattern Analysis and Machine Intelligence, 2021, DOI:10.1109/TPAMI.2021.3056510. 

Latex citation:
@article{LearnWeightDist,
  title={Learnable Weighting of Intra-attribute Distances for Categorical Data Clustering with Nominal and Ordinal Attributes},
  author={Zhang, Yiqun and Cheung, Yiu-ming},
  journal={IEEE Transactions on Pattern Analysis and Machine Intelligence},
  year={2021, DOI: 10.1109/TPAMI.2021.3056510},
}
____________________
All rights reserved.


