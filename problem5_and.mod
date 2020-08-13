#------------------------------------------------------
# Auxiliary data for the greedy algorithm (BFD)
#------------------------------------------------------

# set of assigned requests
set AI within I;

# set of opened VMs
set AJ within J;
set newSOL within J;
set bestNeighbor within J; 

# set of unassigned request
set UI within I;

# set of unassigned VMs
set UJ within J;

#current partial solution
param C {1..M} default 0;

# request occupancy value
param O_1{i in I} := w[i]/B_c + cpu[i]/B_CPU + m[i]/B_m;

# VM residual capacity
param res_B_c {1..M} default B_c;
param res_B_CPU {1..M} default B_CPU;
param res_B_m {1..M} default B_m;

param res_B{j in J} := (res_B_c[j]/B_c + res_B_CPU[j]/B_CPU + res_B_m[j]/B_m)/3;
