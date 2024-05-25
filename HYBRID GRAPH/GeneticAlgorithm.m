clear
clc

%% controling paramters of the GA algortihm
Problem.obj = @Fit;
Problem.nVar = 10; %no of requests
Problem.vm = 6;
Problem.ub = [6,6,6,6,6,6,6,6,6,6];
Problem.lb  = [1,1,1,1,1,1,1,1,1,1];
max_iterations = 10; % Maximum number of iterations
Problem.ETC = [1, 27, 10, 17, 15, 2, 34,12,15,45;
               27,23, 41, 36, 27, 1,  6,34,23, 5;
               12,17, 13, 31, 47, 37,41,27,20,17;
               36,26, 16, 42,  4, 42,34,23,45,23;
               12, 3, 23,  8,  3,  9,34,18,20,19
               29,44,  8, 45, 11, 33,47,50, 1,10] ;

Problem.RCU = [12, 8, 10,  3, 18, 9];
M = 30; % number of chromosomes (cadinate solutions)
N = Problem.nVar;  % number of genes (variables)
MaxGen = 50;
Pc = 0.95;
Pm = 0.6;
Er = 0.4;
[BestChrom_ga, cgcurve_ga] = GA(M, N, MaxGen, Pc, Pm, Er, Problem, max_iterations);
hb(Problem, BestChrom_ga, max_iterations, MaxGen, cgcurve_ga);



