function [Cf_desired,pred_index,index_test_flag,Cf_test_flag] = Graph_Realization(X,Ahat,n)

pred_index = zeros(1,n+1);
nDep = size(Ahat,1);
nIndep = n - nDep;
X_vars = [1:n]';

% rref on Ahat based on column pivoting
% Row pivoting may result in zero division error sometimes
for i=1:nDep
    [~,I] = max(Ahat(i,:));
    Ahat(:,[i,I]) = Ahat(:,[I,i]);
    X_vars([i,I],1)=X_vars([I,i],1);
    Ahat(i,:)=Ahat(i,:)/norm(Ahat(i,i));
    for j = 1:nDep
        if (j~=i)
            Ahat(j,:)=Ahat(j,:)-Ahat(i,:)*Ahat(j,i);
        end
    end
end

d_vars = X_vars(1:nDep);
id_vars = X_vars(nDep+1:end);

%% Rounding the coeffients to 0,1 or -1 based on nearest neighbour rule
Cf = Ahat;
Cf(Cf>0.5)=1;
Cf(Cf<-0.5)=-1;
Cf=round(Cf);
assignin('base','Cf',Cf);

%%Transforming the cutset matrix into desired form
Cf_desired = Cf;
for i=1:nDep
    temp = sum(Cf_desired(i,nDep+1:end));
    if temp>=0
        temp_vars = X_vars(Cf_desired(i,:)~=0);
        temp_ind = find(Cf_desired(i,:)~=0);
        [~,I]=max(X(temp_vars,1));
        I = temp_ind(I);
        Cf_desired(:,[i,I]) = Cf_desired(:,[I,i]);
        X_vars([i,I],1)=X_vars([I,i],1);
        Cf_desired = round(rref(Cf_desired));
    end
end
assignin('base','X_vars',X_vars);
Cc_desired = Cf_desired(:,nDep+1:n);

%% Testing if cutset matrix is in desired form
if any(any(Cc_desired>0)==1) || any(any(Cc_desired<-1)==1)
    Cf_test_flag=0;
else
    Cf_test_flag=1;
end


%% Determining the exact nodal connectivity from Cf_desired
if Cf_test_flag==1
    temp_Cc = [sum(abs(Cc_desired),2) X_vars(1:nDep) Cc_desired];
    temp_Cc = sortrows(temp_Cc,-1);
    Cc_desired = temp_Cc(:,3:end);  
    X_vars(1:nDep) = temp_Cc(:,2);
    pred_index(X_vars(1))=n+1;        
    for i=2:nDep
        temp_row1 = find(Cc_desired(i,:)==-1);
        for j=i-1:-1:1
            temp_row2 = find(Cc_desired(j,:)==-1);
            if ~isempty(intersect(temp_row1,temp_row2))
                pred_index(X_vars(i))=X_vars(j);
                break
            end
        end
    end
    for i=1:nIndep
        for j=nDep:-1:1
            if Cc_desired(j,i)==-1
                pred_index(X_vars(nDep+i))=X_vars(j);
                break
            end
        end
    end
end
                
%% Testing if a connected rooted tree is obtained
if sum(pred_index==0)>1
    index_test_flag=0;
else
    index_test_flag=1;
end
    

        
    




