function [Inter_sim_matrix, Intra_sim_matrix, Combine_sim_matrix]=CMS_similarity(data,a)
% this is the code CMS of paper: Unsupervised Coupled Metric Similarity for Non-IID Categorical Data, TKDE, 2018
% input is the data matrix in which each value is represented by unique number
% a is the combination parameter for inter simialrity and intra similarity and the default value is 0.5
% output is the value similarity

% a=0.5;
[num_obj,num_att]=size(data);

num_value=length(unique(data(:)));
% for i=1:num_att
%     num_value_i=length(unique(data(:,i)));
%     num_value=num_value+length(unique(data(:,i)));
% end

%% build the value graph
g_value=zeros(num_value,num_value);
for i=1:num_obj
    for j=1:num_att
        for k=j:num_att
        index_j=data(i,j);
        index_k=data(i,k);
        if index_j==index_k
            g_value(index_j,index_k)=g_value(index_j,index_k)+1;
        else
            g_value(index_j,index_k)=g_value(index_j,index_k)+1;
            g_value(index_k,index_j)=g_value(index_k,index_j)+1;
        end
        end
    end
end
fre_table=diag(g_value);


dim=size(data);
% n=dim(1);
d=dim(2);
% matrix=ones(n,n);
% fre_Hash=cal_freHash(data);
%format 1_2 means attribute 1 value 2
%conditional probability between attribute values 
 % format: 1_2to2_3, 1_v1 means value 2 of attribute 1 



% keyset_inter={'ini'};
% valueset_inter=[1];
Inter_sim_matrix=zeros(num_value,num_value);
Intra_sim_matrix=zeros(num_value,num_value);
Combine_sim_matrix=zeros(num_value,num_value);
for i=1:d
    vec=unique(data(:,i));
    for j=1:length(vec)
        v1=vec(j);
        for jj=j:length(vec)
           v2=vec(jj);      
           if v1==v2
                Intra_sim_matrix(v1,v2)=1;
                Intra_sim_matrix(v2,v1)=1;
                Inter_sim_matrix(v1,v2)=1;
                Inter_sim_matrix(v2,v1)=1;
                Combine_sim_matrix(v1,v2)=1;
                Combine_sim_matrix(v2,v1)=1;
           else
                %%calculate intra similarity
                x=fre_table(v1);
                y=fre_table(v2);
                intra_sim=(log(x+1)*log(y+1))/(log(x+1)+log(y+1)+(log(x+1)*log(y+1)));
                Intra_sim_matrix(v1,v2)=intra_sim;
                Intra_sim_matrix(v2,v1)=intra_sim;
               
                %%calculate inter similarity
                inter=0;
                for l=1:d
                    minicp=0;
                    
                    if l~=i
                        u1=data(:,i)==v1;
                        u2=data(:,i)==v2;
                        u3=intersect(data(u1,l),data(u2,l));
                        
                        if ~isempty(u3)
                            ICPmin=0;
                            ICPmax=0;
                            for k=1:length(u3)
                                u=u3(k);
                                oc_u_v1=g_value(u,v1);
                                oc_u_v2=g_value(u,v2);
                                ICP1=oc_u_v1/fre_table(v1);
                                ICP2=oc_u_v2/fre_table(v2);
                                ICPmin=ICPmin+min(ICP1,ICP2);
                                ICPmax=ICPmax+max(ICP1,ICP2);

                            end
                            minicp=ICPmax/(2*ICPmax-ICPmin);
                        end
                    end
                inter=inter+minicp;
                end
                inter_sim=inter/(d-1);
 %               if inter_sim==0
  %                  attribute_sim=intra_sim;
  %              else
                    %attribute_sim=(a^2+1)*intra_sim*inter_sim/((a^2*intra_sim)+inter_sim);
                    attribute_sim=1/((1-a)*(1/intra_sim)+a*(1/inter_sim));
                    %attribute_sim=(1-a)*intra_sim+a*inter_sim;

    %            end
                Inter_sim_matrix(v1,v2)=inter_sim;
                Inter_sim_matrix(v2,v1)=inter_sim;
                Combine_sim_matrix(v1,v2)=attribute_sim;
                Combine_sim_matrix(v2,v1)=attribute_sim;

            end
        end
        
    end    
end

% function freHash=cal_freHash(data)
% dim=size(data);
% d=dim(2);
% n=length(unique(data));
% keyset={};
% valueset=zeros(1,n);
% k=1;
% for i=1:d
%     vector=data(:,i);
%     set=unique(vector);
%     vec_n=length(set);
%     for j=1:vec_n
%         M=find(vector==set(j));
%         feq=length(M);   
%         keyset(k)={[num2str(i),'_',num2str(set(j))]};
%         valueset(k)=feq;
%         k=k+1;
%     end
%     
%     
% end
% freHash=containers.Map(keyset,valueset);
% %keys(freHash)
% %values(freHash)
% end
           
            
            
            
            
            
            
            
            
            
            
