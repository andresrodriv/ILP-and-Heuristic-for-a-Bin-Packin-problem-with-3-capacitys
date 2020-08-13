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

# Current total number of cover inequalities
param nc default 0;
# Set of indices for the cover inequalities
set C := 1..nc;
# Set of items composing each cover
set CI{C} within {I,J} default {};

#----------------------------------------------------------
# Integer Linear Programming model for the bin packing
#----------------------------------------------------------

#VARIABLES
var y{J}, binary, default 1;	#1 if VM j is open, 0 otherwise

var x{I,J} >= 0, <= 1;	#1 if request i is assigned to VM j, 0 otherwise

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
	
subject to just1Frac{j in J}:
	N - count {i in I} (x[i,j] == 0 or x[i,j] == 1) <= 1; 

# Constraints for each cover inequality
subject to Cover {c in C}:
	sum {(i,j) in CI[c]} x[i,j] <= card(CI[c]) - 1;


#--------------------------------------------------
#                 Separation problem
#--------------------------------------------------

# The separation problem looks for a cover inequality
# violated by the current LP solution

# Fractional solution of current LP
param x_star{I} >= 0, <= 1;

# Binary variable for item in the cover
var u{I} binary;

# Objective function: Find the most violated cover inequality
minimize Violation: 
	(sum {i in I} (1 - x_star[i])*u[i]);

# Cover condition constraint
subject to CoverCondition_c:
	sum {i in I} w[i]*u[i] >= B_c + 1;

subject to CoverCondition_cpu:
	sum {i in I} cpu[i]*u[i] >= B_CPU + 1;

subject to CoverCondition_m:
	sum {i in I} m[i]*u[i] >= B_m + 1;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	