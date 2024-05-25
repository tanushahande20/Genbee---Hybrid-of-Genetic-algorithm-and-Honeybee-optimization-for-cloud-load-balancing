function [BestChrom, cgcurve] = GA(M, N, MaxGen, Pc, Pm, Er, Problem, max_iterations)
    %% Initialization
    cgcurve = zeros(1, MaxGen); % Adjust the size of cgcurve to only store fitness values for GA iterations
    [population] = initialization(M, N, Problem);
    for i = 1:M
        population.Chromosomes(i).fitness = Problem.obj(population.Chromosomes(i).Gene(:), Problem);
    end

    all_fitness_values = [population.Chromosomes(:).fitness];
    [cgcurve(1), ~] = max(all_fitness_values);
    g = 1;

    %% Main loop
    for g = 1:MaxGen
        disp(['Generation #', num2str(g)]); % Display the generation number

        % Calculate the fitness values
        for i = 1:M
            population.Chromosomes(i).fitness = Fit(population.Chromosomes(i).Gene(:), Problem);
        end

        for k = 1:2:M
            % Selection
            [parent1, parent2] = selection(population);

            % Crossover
            [child1, child2] = crossover(parent1, parent2, Pc, 'single');
            % Mutation
            [child1] = mutation(child1, Pm, Problem);
            [child2] = mutation(child2, Pm, Problem);

            newPopulation.Chromosomes(k).Gene = child1.Gene;
            newPopulation.Chromosomes(k+1).Gene = child2.Gene;
        end

        for i = 1:M
            newPopulation.Chromosomes(i).fitness = Problem.obj(newPopulation.Chromosomes(i).Gene(:), Problem);
        end
        % Elitism
        [newPopulation] = elitism(population, newPopulation, Er);

        population = newPopulation;

        all_fitness_values = [population.Chromosomes(:).fitness];
        [cgcurve(g), ~] = max(all_fitness_values);
        disp(max(all_fitness_values));
    end

    for i = 1:M
        population.Chromosomes(i).fitness = Problem.obj(population.Chromosomes(i).Gene(:), Problem);
    end

    [max_val, indx] = sort([population.Chromosomes(:).fitness], 'descend');

    BestChrom.Gene = population.Chromosomes(indx(1)).Gene;
    BestChrom.Fitness = population.Chromosomes(indx(1)).fitness;
    figure;
    disp('___________________________');
    disp('GENETIC ALGORITHM BEST CHROMOSOME: ');
    disp(BestChrom.Gene);
    disp('BEST FITNESS:');
    disp(BestChrom.Fitness);
    calload(BestChrom.Gene, Problem);

    % Constructing x-axis values starting from 1 to the length of cgcurve
    x = 1:length(cgcurve);
    % Using cgcurve as y-axis values
    y = cgcurve;

    % Setting y-axis limit to start from the minimum non-zero value and up to the maximum fitness value achieved
    ylim([min(cgcurve(cgcurve > 0)), max(cgcurve)]);

    % Plotting the convergence curve
    plot(x, y, 'b');
    xlabel('Generation');
    ylabel('Fitness');
    title('Convergence Curve');
end

