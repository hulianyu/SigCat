% HD-NDW clustering algorithm

function LctRecC = HD_NDW_Clustering(X,K,ordinal_num)
%% Pm, Modes
Pm.Owd = ordinal_num; % the number of ordinal attribute, the default value is half of all attributes
[Pm.Xlth,Pm.Xwd]=size(X);
Pm.k = K;
[N,M]=size(X);
Modes=X(randperm(N,K),1:M);
%%
% obtain the number of possible values of each attribute
NumVal=zeros(1,Pm.Xwd);
for i=1:Pm.Xwd
    NumVal(i)=length(unique(X(:,i)));
end
% convert random initialized Modes into ModeMtx
ModeMtx=cell(1,Pm.Xwd);
for j=1:Pm.Xwd
    ModeMtx{j}=zeros(Pm.k,NumVal(j));
    for k=1:Pm.k
        ModeMtx{j}(k,Modes(k,j))=1;
    end
end
% initialize the distance weights
CateW=cell(1,Pm.Xwd);
CateWSum=sum(NumVal.*(NumVal-1)/2);
for i=1:Pm.Xwd
    CateW{i}=(1-eye(NumVal(i)))/CateWSum;
end
% compute distances of each attribute
AttMtx = HD_Dist(X,Pm);
% conduct partition and weights learning
LctRecFOld=zeros(Pm.Xlth,1);
LctRecC=zeros(Pm.Xlth,1);
FChange=1;
LoopD=0;
while FChange==1 && LoopD<=50
    LoopD=LoopD+1;
    LctRecMOld=zeros(Pm.Xlth,1);
    MChange=1;
    LoopG=0;
    % iteratively search for the optimal partition
    while MChange==1 && LoopG<=50
        LoopG=LoopG+1;
        for i=1:Pm.Xlth
            DistMtx=zeros(Pm.k,Pm.Xwd);
            for k=1:Pm.k
                for j=1:Pm.Xwd
                    for h=1:NumVal(j)
                        DistMtx(k,j)=DistMtx(k,j)+...
                            ModeMtx{j}(k,h)*(AttMtx{j}(X(i,j),h)*CateW{j}(X(i,j),h));
                    end
                end
            end
            DistVec=sqrt(sum(DistMtx.^2,2));
            [~,Winner]=min(DistVec);
            LctRecC(i)=Winner;
        end
        % update ModeMtx
        for k=1:Pm.k
            for j=1:Pm.Xwd
                ClusterVal=X((LctRecC==k),j);
                ValSta=zeros(1,NumVal(j));
                for m=1:NumVal(j)
                    ValSta(m)=sum(ClusterVal==m);
                end
                ModeMtx{j}(k,:)=ValSta/sum(ValSta);
            end
        end
        % judge convergence of partition learning
        if sum(LctRecMOld-LctRecC)==0
            MChange=0;
        else
            LctRecMOld=LctRecC;
        end
    end
    % judge convergence of weights learning
    if sum(LctRecFOld-LctRecC)==0
        FChange=0;
    else
        LctRecFOld=LctRecC;
        % distance weights updating
        CateWSum=0;
        for i=1:Pm.Xwd
            ValLth=zeros(1,NumVal(i));
            for m=1:NumVal(i)
                ValLth(m)=sum(X(:,i)==m);
            end
            DistCtMtxInter=zeros(NumVal(i));
            for m=1:NumVal(i)-1
                for h=m+1:NumVal(i)
                    for k1=1:Pm.k
                        Clust1Val=X(LctRecC==k1,i);
                        for k2=1:Pm.k
                            Clust2Val=X(LctRecC==k2,i);
                            MLth=sum(Clust1Val==m);
                            HLth=sum(Clust2Val==h);
                            if k1~=k2
                                DistCtMtxInter(m,h)=DistCtMtxInter(m,h)+...
                                    MLth*HLth*AttMtx{i}(m,h)/(ValLth(m)*ValLth(h));
                            end
                        end
                    end
                    DistCtMtxInter(h,m)=DistCtMtxInter(m,h);
                end
            end
            CateW{i}=DistCtMtxInter;
            CateWSum=CateWSum+sum(CateW{i},'all');
        end
        for i=1:Pm.Xwd
            CateW{i}=CateW{i}/(CateWSum/2);
        end
    end
end
end
