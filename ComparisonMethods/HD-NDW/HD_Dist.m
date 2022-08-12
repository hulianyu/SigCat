
% compute distances of each attribute

function AttMtx = HD_Dist(X,Pm)
ValNum=zeros(Pm.Xwd,1);
for i=1:Pm.Xwd
    ValNum(i)=max(X(:,i));
end
% obtain distance matrices of the data attributes
AttMtx=cell(Pm.Xwd,1);
for i=1:Pm.Xwd
    DistMtx=zeros(ValNum(i));
    for m=1:ValNum(i)-1
        for h=m+1:ValNum(i)
            SubDist=zeros(1,Pm.Xwd);
            for j=1:Pm.Xwd
                if j<=Pm.Owd % computation in the ordinal(j) case
                    MaxCost=ValNum(j)-1;
                    MCor=X(X(:,i)==m,j);
                    ConM=zeros(1,ValNum(j));
                    for g=1:ValNum(j)
                        ConM(g)=sum(MCor==g);
                    end
                    ConM=ConM/length(MCor);
                    HCor=X(X(:,i)==h,j);
                    ConH=zeros(1,ValNum(j));
                    for g=1:ValNum(j)
                        ConH(g)=sum(HCor==g);
                    end
                    ConH=ConH/length(HCor);
                    ConDiff=ConM-ConH;
                    Cost=0;
                    for g=1:ValNum(j)-1
                        ConDiff(g+1)=ConDiff(g+1)+ConDiff(g);
                        Cost=Cost+abs(ConDiff(g));
                        ConDiff(g)=0;
                    end
                    SubDist(j)=Cost/MaxCost;
                end
                if j>Pm.Owd % computation in the nominal(j) case
                    MCor=X(X(:,i)==m,j);
                    HCor=X(X(:,i)==h,j);
                    SubDistVct=zeros(1,ValNum(j));
                    SubDistW=zeros(1,ValNum(j));
                    for g=1:ValNum(j)
                        ConM=zeros(1,2);
                        ConM(1)=sum(MCor==g);
                        ConM(2)=sum(MCor~=g);
                        ConH=zeros(1,2);
                        ConH(1)=sum(HCor==g);
                        ConH(2)=sum(HCor~=g);
                        SubDistW(g)=(ConM(1)+ConH(1))/(length(MCor)+length(HCor));
                        ConM=ConM/sum(ConM);
                        ConH=ConH/sum(ConH);
                        ConDiff=ConM-ConH;
                        SubDistVct(g)=sum(ConDiff(ConDiff>=0));
                    end
                    SubDist(j)=sum(SubDistVct)/sum(SubDistW~=0);
                end
            end
            DistMtx(m,h)=mean(SubDist);
            DistMtx(h,m)=DistMtx(m,h);
        end
    end
    % accumulate adjacent distances to form distances between any two categories
    if i<=Pm.Owd
        AttMtx{i}=zeros(ValNum(i));
        for m=1:ValNum(i)-1
            for h=m+1:ValNum(i)
                DistCand=zeros(1,ValNum(i));
                for t=m:h-1
                    DistCand(t)=DistMtx(t,t+1);
                end
                AttMtx{i}(m,h)=sum(DistCand);
                AttMtx{i}(h,m)=AttMtx{i}(m,h);
            end
        end
    end
    if i<=Pm.Owd
        AttMtx{i}=AttMtx{i}/max(max(AttMtx{i}));
    else
        AttMtx{i}=DistMtx;
    end
end
end

