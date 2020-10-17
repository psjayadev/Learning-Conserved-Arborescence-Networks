function [X,Sigma_e] = Data_Generation(n,l_Nnodes,nNodes,e_index,Nlayers,NSamples,SNR,noise_var,Nrepeats,noise_flag,noise_case)

% Initialization
mean_signal_choice = [100 200 300];        % Choice of mean value of a flow measurement
sdv_signal_choice = [10 20 30];            % Choice of standard deviation of a flow measurement
var_signal = zeros(n,1);

%% Randomly generating samples for sink flows
X_noisefree = zeros(n,NSamples);
for i=1:nNodes(1,Nlayers)
    j=e_index(Nlayers,i);
    select = ceil(rand()*3);
    X_noisefree(j,:) = randn(1,NSamples)*sdv_signal_choice(select)+mean_signal_choice(select);
    var_signal(j) = sdv_signal_choice(select)^2;
end


%% Obtaining the corresponding measurements along the non-sink flow edges
for i=Nlayers:-1:2
    l=1;
    for j=1:nNodes(1,i-1)
        k=l_Nnodes(i,j);
        if (k==0)
            select = ceil(rand(1,1)*3);
            X_noisefree(e_index(i-1,j),:) = randn(1,NSamples)*sdv_signal_choice(select)+mean_signal_choice(select);
            var_signal(e_index(i-1,j)) = sdv_signal_choice(select)^2;
        else
        while(k>0)
            X_noisefree(e_index(i-1,j),:)=X_noisefree(e_index(i-1,j),:)+X_noisefree(e_index(i,l),:); 
            var_signal(e_index(i-1,j)) = var_signal(e_index(i-1,j)) + var_signal(e_index(i,l));
            k=k-1;
            l=l+1;
        end
        end
    end
end
sdv_signal = sqrt(var_signal);

if noise_flag==0
    X = X_noisefree;
    Sigma_e = [];

else    
    %% Addition of Gaussian noise to the data set
    if noise_case==0
        sdv_noise = sdv_signal./(noise_var*ones(n,1));
    else
        sdv_noise = sdv_signal./(SNR*ones(n,1));
    end
    Sigma_e = diag(sdv_noise.^2);      % Noise Covariance Matrix
    sdv_noise = repmat(sdv_noise,1,NSamples);
    
    X = cell(1,Nrepeats);
    for i=1:Nrepeats
        X{1,i} = X_noisefree+sdv_noise.*randn(n,NSamples);
    end
end
            