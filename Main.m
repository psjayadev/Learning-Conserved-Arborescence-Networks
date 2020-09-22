%% A code to reconstruct an arborescence network which could be a binary network, a long-thin network, a short-fat network, from flow data
% The flow data pertaining to the network can be given as input 

noise_flag = -1;
Nrepeats = 1;
SNR=0;
noise_var = 0;

data_flag = input('<strong> Enter 1 if you want to feed data : \n Enter 2 if you want a random network and data to be generated </strong>\n');
if isempty(data_flag)
    fprintf(2, 'No input given: Random Network will be generated by default\n');
    data_flag = 2;
elseif (data_flag ~= 1 && data_flag ~=2)
    fprintf(2, 'Invalid input: Random Network will be generated by default\n');
    data_flag = 2;
end


if (data_flag ==1)
    fprintf('\n Checking the provision of data in the workspace with the variable name X \n');
    test = exist('X','var');
    if test==1
        fprintf(2, 'Data provided\n')
    else
        fprintf(2, 'Data NOT provided\n')
        return
    end

    while (noise_flag ~= 0 && noise_flag ~=1)
    noise_flag = input('\n <strong> Enter 1 if data is noisy : Enter 0 if data is noisefree </strong> \n');
        if isempty(noise_flag)
            fprintf(2, 'No input given \n');
            noise_flag = -1;
        elseif (noise_flag ~= 0 && noise_flag ~=1)
            fprintf(2, 'Invalid input \n');
        end
    end    

    if noise_flag==1
        temp = input('\n <strong> Enter 1 for homoscedastic case (or) Enter 0 for heteroscedastic case and and provide a variable SNR comprising SNR values </strong> \n');
        test = exist('SNR','var');
        if isempty(temp)
            fprintf(2, 'No input given \n');
            return
        elseif temp==1
            SNR = temp;
            fprintf(2, 'Homosedastic Case \n')
        elseif test==1 && temp==0
            if e==size(SNR,1)
                fprintf(2, 'Heteroscedastic case : SNR values provided \n')
            else
                fprintf(2, 'Heteroscedastic case : SNR values provided but invalid \n SNR should be a column matrix of dimension equal to no. of variables in the data \n'); 
            return
            end
        elseif temp~=0 && temp~=1
            fprintf(2, 'Invalid input \n');
            return
        else
            fprintf(2, 'SNR values NOT provided \n')
            return
        end
    end

else
    network_flag = input('\n <strong> Enter 1 for Binary Network : Enter 2 for Long-Thin Network : Enter 3 for Short-Fat Network </strong> \n');
    if isempty(network_flag)
        fprintf(2, 'No input given: Binary network chosen by default \n');
        network_flag = 1;
    elseif (network_flag ~= 1 && network_flag ~=2 && network_flag ~=3)
        fprintf(2, 'Invalid input: Binary network chosen by default \n');
        network_flag = 1;
    end

    
    if network_flag==1
        network_type = 'Binary';
        Nlayers = input('\n <strong> Enter a value between 3 and 10 to choose the no. of layers to be in the generated network </strong> \n');
        if isempty(Nlayers)
            fprintf(2, 'No input given: The no. of layers set to default value 3 \n')
            Nlayers=3;
        elseif Nlayers<3
            fprintf(2, 'Invalid input: The no. of layers set to 3 \n')
            Nlayers=3;
        elseif Nlayers>10
            fprintf(2, 'Invalid input: The no. of layers capped to 10 \n')
            Nlayers= 10;
        end
    elseif network_flag==2
        network_type = 'Long-Thin';
        Nlayers = input('\n <strong> Enter a value between 5 and 10 to choose the number of layers to be in the generated network </strong> \n');
        if isempty(Nlayers)
            fprintf(2, 'No input given: The no. of layers set to default value 5 \n')
            Nlayers=5;
        elseif Nlayers<3
            fprintf(2, 'Invalid input: The no. of layers set to 5 \n')
            Nlayers=5;
        elseif Nlayers>10
            fprintf(2, 'Invalid input: The no. of layers capped to 10 \n')
            Nlayers= 10;
        end
    else
        network_type = 'Short-Fat';
        Nlayers = input('\n <strong> Enter a value between 3 and 5 to choose the number of layers to be in the generated network </strong> \n');
        if isempty(Nlayers)
            fprintf(2, 'No input given: The no. of layers set to default value 3 \n')
            Nlayers=3;
        elseif Nlayers<3
            fprintf(2, 'Invalid input: The no. of layers set to 3 \n')
            Nlayers=3;
        elseif Nlayers>10
            fprintf(2, 'Invalid input: The no. of layers capped to 5 \n')
            Nlayers= 5;
        end
    end
    
    [e,l_Nnodes,nNodes,e_index,true_index] = Network_Generation(network_flag,Nlayers);
    fprintf(2, '\nRandomly generated a %s network with %d layers, %d nodes and %d edges\n',network_type,Nlayers,e+1,e);


    Nmultiple = input('\n <strong> For no. of samples, enter a value between 1 and 100 (multiple of no. of edges) </strong> \n');
    if isempty(Nmultiple)
        fprintf(2,'No input given: Set to default value of 1 \n')
        Nmultiple=1;
    elseif (Nmultiple<1 || Nmultiple>100)
        fprintf(2,'Invalid input: Set to default value of 1 \n');
        Nmultiple=1;
    else
        Nmultiple = round(Nmultiple);
    end

    noise_flag = input('\n <strong> Enter 1 if data is to be noisy : Enter 0 if data is to be noisefree </strong> \n');
    if isempty(noise_flag)
        fprintf(2, 'No input given: Generating noisefree data by default \n')
        noise_flag=0;
    elseif (noise_flag ~= 0 && noise_flag ~=1)
        fprintf(2, 'Invalid input: Generating noisefree data by default \n');
        noise_flag=0;
    end


    if noise_flag==1
        noise_case = input('\n <strong> Enter 0 for homoscedastic case (or) Enter 1 for heteroscedastic case </strong> \n');
        if isempty(noise_case)
            fprintf(2, 'No input given: Homoscedastic case chosen by default with noise variance of 10 \n');
            noise_case = 0;
            noise_var = 10;
        elseif noise_case~=0 && noise_case~=1
            fprintf(2, 'Invalid input \n');
            return
        elseif noise_case==0
            noise_var = input('\n <strong> Choose noise variance in the range of 1-20 for homoscedastic case </strong> \n');
            if isempty(noise_var)
                fprintf(2, 'No input given: Noise variance of 10 chosen by default \n');
                noise_var = 10;
            elseif (noise_var<1 || noise_var>20)
                fprintf(2, 'Invalid input: Noise variance of 10 chosen by default \n');
                noise_var = 10;
            end
        else
            SNR = input('\n <strong> Choose SNR in the range of 5-500 for heteroscedastic case </strong> \n');
            if isempty(SNR)
                fprintf(2, 'No input given: SNR of 50 chosen by default \n');
                SNR = 50;
            elseif (SNR<5 || SNR>500)
                fprintf(2, 'Invalid input: SNR of 50 chosen by default \n');
                SNR = 50;
            end
        end

        Nrepeats = input('\n <strong> Enter a value between 1-100 for the no. of datasets to be generated with different noise samples, for the network </strong> \n');
        if isempty(Nrepeats)
            fprintf(2, 'No input given: Set to default of 10\n')
            Nrepeats=10;
        elseif Nrepeats<1 || Nrepeats>100
            fprintf(2, 'Invalid number: Set to default of 10\n')
        else
            Nrepeats = round(Nrepeats);
        end


        NSamples = e*Nmultiple;
        fprintf(2, 'Randomly generating %d noisy datasets with %d samples each\n',Nrepeats,NSamples);

    else
        SNR = [];
        NSamples = e*Nmultiple;
        fprintf(2, 'Randomly generating a noisefree dataset with %d samples \n',NSamples);
    end

    [X,Sigma_e] = Data_Generation(e,l_Nnodes,nNodes,e_index,Nlayers,NSamples,SNR,noise_var,Nrepeats,noise_flag,noise_case);      
    
 end


%% Steps to Graph Realization from Data
if data_flag==1
    e = size(X,1);
    NSamples = size(X,2);
    
    % Finding the Error Covariance matrix
    if noise_flag == 0
        Sigma_e = [];
    else
        if size(SNR,1)==1
            sdv_noise = ones(e,1);
        else
            sdv_noise = sqrt(sdv(X,0,2).^2./SNR);
        end
        Sigma_e = diag(sdv_noise.^2);
    end
    
    tic                                                       % Starting the timer
    [Ahat,sin_vals] = Linear_Model(X,e,NSamples,noise_flag,Sigma_e);     % Finding a linear model by applying PCA on data
    [Cf_desired,pred_index,index_test_flag,Cf_test_flag] = Graph_Realization(X,Ahat,e);     % Calling a function to realize the graph from the PCA model
    time = toc;                                               % Stopping the timer and saving the time taken
    
    
    if noise_flag==0 && Cf_test_flag==0 
        fprintf(2, 'The arborescence network could not be reconstructed from given data as f-cutset matrix in desired form is not obtained. \n It is because the data does not pertain to a arborescence network. \n');
    elseif noise_flag==1 && Cf_test_flag==0
        fprintf( 2, 'The arborescence network could not be reconstructed from given data as f-cutset matrix in desired form is not obtained. \n It is because either the data does not pertain to a arborescence network or the samples are not sufficient. \n');
    elseif noise_flag==1 && index_test_flag==0
        fprintf(2, 'The arborescence network could not be reconstructed from given data because either the data does not pertain to a arborescence network or the samples are not sufficient. \n');
    else
        fprintf(2, 'The arborescence network is exactly reconstructed from given data in %0.2f seconds and plotted as a graph (tree) \n', time);
        Graph_Plot(pred_index)          % Plotting the graph if the network is exactly reconstructed
    end
    
else
    if noise_flag == 0
        tic
        [Ahat,sin_vals] = Linear_Model(X,e,NSamples,noise_flag,Sigma_e); 
        [Cf_desired,pred_index,index_test_flag,Cf_test_flag] = Graph_Realization(X,Ahat,e);
        time = toc;
        if isequal(pred_index,true_index)
            fprintf(2, 'The arborescence network is exactly identified from given data in %f seconds and plotted as a graph (tree) \n', time);
            Graph_Plot(pred_index)          % Plotting the graph if the network is exactly reconstructed
        end
        
    else
        pred_index = cell(1,Nrepeats);
        Cf_desired = cell(1,Nrepeats);
        test = zeros(1,Nrepeats);
        for i=1:Nrepeats
            tic
            [Ahat,sin_vals] = Linear_Model(X{1,i},e,NSamples,noise_flag,Sigma_e);   % Finding a linear model by applying PCA on data
            [Cf_desired{1,i},pred_index{1,i},index_test_flag(i),Cf_test_flag(i)] = Graph_Realization(X{1,i},Ahat,e);     % Realizing the graph from the PCA model
            t(i) = toc;
            if isequal(pred_index{1,i},true_index)
                test(i)=1;
                temp = i;
            end
        end
        avg_time = sum(t)/Nrepeats;
        avg_test = sum(test)/Nrepeats*100;
        if avg_test==0
            fprintf(2, 'The arborescence network could not be reconstructed from any of %d dataset(s) that were generated \n', Nrepeats);
        else
            fprintf(2, 'The arborescence network is exactly reconstructed in %0.2f percent cases of the %d dataset(s) that were generated at an average time of %f seconds \n', avg_test, Nrepeats, avg_time);
            Graph_Plot(pred_index{1,i})
        end
    end
end










