function [ population ] = initialization(M, N, Problem)

for i = 1 : M
    for j = 1 : N
        population.Chromosomes(i).Gene(j) = randi([1, Problem.vm]);;
    end
end

