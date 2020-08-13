#PARAMETERS

#number of requests
param N; 
set I := 1..N; 	#set I of requests

#number of clusters, feasible subsets of items
param S default N; 

#number of virtual machine
param M;
set J := 1..M;	#set J of virtual machines

#request traffic
param w{1..N};

#request CPU requirement
param cpu{1..N} default 1;

#request memory requirement
param m{1..N} default 1;

#VM capacity
param B_c;
#VM max CPU
param B_CPU default N;
#VM max memory
param B_m default N;

#cluster composition to describe the feasible subset, =1 if the items belong to the subset
param a{1..N,1..S} default 0;

#item profit for the pricing problem
#calculated as the optimal value of the dual variables of
#the current master problem
param pi{1..N} >=0 default 0;

### Part 2 ###

		#####################
		#	MASTER PROBLEM	#
		#####################

#VARIABLES
#cluster selection
var l{1..S} >=0; # we are working with continuous values (continuous relaxation)

#OBJECTIVE
#minimize number of used bins 
minimize VM_CG: 
	sum{i in 1..S} l[i];
	
#CONSTRAINTS	
#assign each item to a bin
subject to cover{i in 1..N}: 
	sum{j in 1..S} a[i,j]*l[j] >= 1; #in this way we consider only the s in which i is present


		#####################
		#  PRICING PROBLEM	#
		#####################	

#VARIABLES
#composition of candidate new cluster
var u{1..N}, binary;	#=1 if item i belongs to s*, 0 otherwise

#OBJECTIVE
#maximize profit of candidate new cluster
maximize profit:
	sum{i in 1..N} pi[i]*u[i];
		
#CONSTRAINTS	
#candidate new cluster must fit a bin
subject to capacity_traffic:
	sum{i in 1..N} w[i]*u[i] <= B_c;
	
subject to capacity_CPU:
	sum{i in 1..N} cpu[i]*u[i] <= B_CPU;

subject to capacity_memory:
	sum{i in 1..N} m[i]*u[i] <= B_m;

#PROBLEM DEFINITION

problem master: l, VM_CG, cover; 

problem pricing: u, profit, capacity_traffic, capacity_CPU, capacity_memory;

