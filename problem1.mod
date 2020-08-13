#PARAMETERS

#number of requests
param N; 
set I := 1..N; 	#set I of requests

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

### Part 1 ###
#VARIABLES
var y{J}, binary;	#1 if VM j is open, 0 otherwise
var x{I,J}, binary;	#1 if request i is assigned to VM j, 0 otherwise

#OBJECTIVE FUNCTION
#minimize number of used virtual machines
minimize VMs:
	sum{j in J} y[j];
	
#CONSTRAINTS
#assignment constraints
subject to assignment{i in I}:
	sum{j in J} x[i,j] = 1;		#every requests must be assigned to one and only one VM
	
#capacity constraints
subject to VM_capac{j in J}:
	sum{i in I} w[i]*x[i,j] <= B_c;
	
subject to VM_max_CPU{j in J}:
	sum{i in I} cpu[i]*x[i,j] <= B_CPU;

subject to VM_max_memory{j in J}:
	sum{i in I} m[i]*x[i,j] <= B_m;

#consistency constraints
subject to consistency{i in I, j in J}:
	x[i,j] <= y[j];
	
subject to data_consistency{i in I}:
	w[i] <= B_c and cpu[i] <= B_CPU and m[i] <= B_m;