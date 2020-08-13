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
param cpu{1..N};

#request memory requirement
param m{1..N};

#VM capacity
param B_c;
#VM max CPU
param B_CPU;
#VM max memory
param B_m;

# surrogate relaxation multipliers
param m1{1..M} default 0;
param m2{1..M} default 0;
param m3{1..M} default 0;

param m1_old{1..M} default 1;
param m2_old{1..M} default 1;
param m3_old{1..M} default 1;

# step for updating multipliers
param t default 1;
param flag default 0;

### Part 3 ###
#----------------------------------------------------------
# Integer Linear Programming model for the bin packing
#----------------------------------------------------------

#VARIABLES
var y{J}, binary;	#1 if VM j is open, 0 otherwise
var x{I,J}, binary;	#1 if request i is assigned to VM j, 0 otherwise

#OBJECTIVE FUNCTION
#minimize number of used virtual machines
minimize VMs:
	sum{j in J} y[j];

#CONSTRAINTS
#assignment constraints
subject to Assignment{i in I}:
	sum{j in J} x[i,j] = 1;		#every requests must be assigned to one and only one VM
	
subject to Consistency {j in J, i in I}:
	x[i,j] <= y[j];

#capacity constraints
subject to VM_max_traffic{j in J}:
	sum{i in I} w[i]*x[i,j] <= B_c*y[j];
	
subject to VM_max_CPU{j in J}:
	sum{i in I} cpu[i]*x[i,j] <= B_CPU*y[j];

subject to VM_max_memory{j in J}:
	sum{i in I} m[i]*x[i,j] <= B_m*y[j];

#----------------------------------------------------------
# Surrogate Relaxation (SR)
#----------------------------------------------------------

# SR capacity constraint #Da cambiare
subject to SurrogateCapacity_1:
	sum {j in J, i in I} m1[j]*w[i]*x[i,j] <= sum {j in J} m1[j]*B_c*y[j];
	
#subject to SurrogateCapacity_2:
#	sum {j in J} sum {i in I} m2[j]*cpu[i]*x[i,j] <= sum {j in J} m2[j]*B_CPU*y[j];
	
#subject to SurrogateCapacity_3:
#	sum {j in J} sum {i in I} m3[j]*m[i]*x[i,j] <= sum {j in J} m3[j]*B_m*y[j];