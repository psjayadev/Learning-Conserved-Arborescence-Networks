# Learning-Conserved-Arborescence-Networks
This repository presents MATLAB codes to learn the topology of a conserved arborescence network from data. The code has a main function and 5 supporting functions each defined in a separate .m file. The following the functionalities of each of the functions:

# 1) Main 
This is the main function of the code which is to be run to begin the program. All the user interactions and defaults are coded in this function right from taking input data to generating networks to generating data. The user can interactively explore all the functionalities of this code via this main function.

# 2) Network_Generation
This function generates a network based on the choices of the user. The code also indexes all the edges randomly. It also generates a vector which represents the network connectivity. The total number of nodes, layers, nodes at each layer and index information of edges are returned by this function.

# 3) Data_Generation
This function generates flow data pertaining to the generated network. Depending on the users choice, it also adds Gaussian noise, i.d. or i.i.d., to the dataset. It returns data matrix along with noise covariance matrix to the main function. 

# 4) Linear_Model
This function identifies a linearmodel from flowdata, either generated or user provided. If finds the order of the linear model and returns it along with the singular values of data matrix.

# 5) Graph_Realisation
This function gets transforms the model matrix into an f-cutset matrix of the conservation graph. The f-cutset matrix is transformed as desired and verified if it has the
desired form. If it is in desired form, the vector representation of the network topology is obtained from the desired f-cutset matrix. This function returns the desired f-cutset matrix and vector representation of the network. The vector is compared with the true one to verify if the topology is correctly reconstructed.

# 6) Graph_Plot
This function is used to plot the network topology from its vector representation. It uses an inbuilt graph function in MATLAB.

The complete details about the code are given in the documentation.pdf attached in this repository.
