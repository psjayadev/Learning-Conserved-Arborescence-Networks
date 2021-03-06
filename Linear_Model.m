%% This function performs PCA on steady state flow data and obtains a linear model explaining the data 

function [Ahat,sin_vals] = Linear_Model(X,n,N,noise_flag,Sigma_e)

%% Getting the Constraint matrix by applying svd
if noise_flag == 0
    [u,s,~]=svd(X);
    sin_vals = s(1:n,1:n);
    for i=1:n
        if s(i,i)<0.1
            m = i;
            break
        end      
    end
    Ahat = u(:,m:n)'; % constraint matrix
else
    L = chol(Sigma_e);
    Xs = inv(L)*X;
    [u,s,~]=svd(Xs);
    
    % Iterative Hypothesis testing to determine the model order
    N_bar = N - (2*n+11)/6;
    for m = n-2:-1:1
        dof = (n-m+2)*(n-m-1)/2;                    % Degrees of freedom
        l_bar = sum(diag(s(m+1:n,m+1:n)))/(n-m);    % Estimating the mean
        l_bar_log = sum(log(diag(s(m+1:n,m+1:n))));
        test_stat = N_bar*((n-m)*log(l_bar)-l_bar_log);     % Calculating the test statistic
        chi_value_95 = chi2inv(0.95,dof);                   % Chi-squared value for 95% confidence interval
        if test_stat > chi_value_95
            m=m+1;
            break
        end
    end
    Ahat = u(:,m+1:n)'*inv(L);      % A linear model of data
    sin_vals = s(1:n,1:n);
end









