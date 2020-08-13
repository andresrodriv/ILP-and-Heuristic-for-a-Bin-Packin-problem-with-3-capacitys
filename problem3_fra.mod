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

# surrogate relaxation multipliers
param la_w{1..M} default 1;
#param la_cpu{1..M} default B_CPU;
#param la_m{1..M} default B_m;

param la_w_old{1..M} default 1;
param la_cpu_old{1..M} default B_CPU;
param la_m_old{1..M} default B_m;


# step for updating multipliers
param t default 1;
param j_stop default 1;

### Part 3 ###
#----------------------------------------------------------
# Integer Linear Programming model for the bin packing
#----------------------------------------------------------

#VARIABLES
var y{J}, binary, default 1;	#1 if VM j is open, 0 otherwise
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
	sum{i in I} w[i]*x[i,j] <= B_c;
	
subject to VM_max_CPU{j in J}:
	sum{i in I} cpu[i]*x[i,j] <= B_CPU;

subject to VM_max_memory{j in J}:
	sum{i in I} m[i]*x[i,j] <= B_m;


#----------------------------------------------------------
# Surrogate Relaxation (SR)
#----------------------------------------------------------

# SR capacity constraint
subject to SurrogateCapacity:
	sum{j in J}(la_w[j] * sum {i in I} (w[i]*x[i,j]))
	#+ sum{j in J}(la_cpu[j] * sum {i in I} (cpu[i]*x[i,j])) +
	#sum{j in J}(la_m[j] * sum {i in I} (m[i]*x[i,j]))
	<=
	B_c * sum{j in J} la_w[j];
	#+ B_CPU * sum{j in J} la_cpu[j] + B_m * sum{j in J} la_m[j];
	
	
	