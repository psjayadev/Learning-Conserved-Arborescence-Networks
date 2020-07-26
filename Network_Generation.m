function [n,l_Nnodes,nNodes,e_index,true_index] = Network_Generation(network_flag,Nlayers)

nIndep = 0;                  

if network_flag==1
    n_range = [2 2];         % max child nodes per node for binary networks
elseif network_flag==2
    n_range = [0 3];         % max child nodes per node for long-thin networks
else
    n_range = [2 5;3 10;0 15;0 20]; % max child nodes per node for short-fat networks which is different at each layer
end
 
    

%% generating a radial network by randomly selecting the no. of layers and no. of nodes at each layer
l_Nnodes = [];
l_Nnodes(1,1)=1; 
i=2;
while(i<=Nlayers)
    if network_flag==1 || network_flag==2
        temp = n_range;
    else
        temp = n_range(i-1,:);
    end
    for j=1:sum(l_Nnodes(i-1,:))
        l_Nnodes(i,j)= temp(1)+round(rand()*range(temp));
        if l_Nnodes(i,j)==1                 % Ensuring there are no nodes with single child node
            l_Nnodes(i,j)=0;
        end
        if l_Nnodes(i,j)==0
            nIndep = nIndep+1;
        end
    end
    if sum(l_Nnodes(i,:))==0
        nIndep = nIndep -1;
    else
        i=i+1;
    end
end

n=sum(sum(l_Nnodes));               % total no. of nodes
nNodes=sum(l_Nnodes,2)';            % No. of nodes layer-wise
nIndep = nIndep + nNodes(end);
nDep = n - nIndep;
X_vars = [1:n]';

%% Randomly indexing all the edges incident on the layer-wise nodes
random=randperm(n); 
k=1;
for i=1:Nlayers
    for j=1:nNodes(1,i)
        e_index(i,j)=random(1,k);
        k=k+1;
    end
end 

%% Vector representation of actual network  
true_index=zeros(1,n+1);
true_index(e_index(1,1))=n+1;
for i=2:Nlayers
    l = 1;
    for j=1:sum(l_Nnodes(i-1,:))
        for k=1:l_Nnodes(i,j)
            true_index(e_index(i,l))=e_index(i-1,j);
            l=l+1;      
        end
    end
end
