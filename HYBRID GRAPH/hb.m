function hb(Problem, BestChrom, max_iterations, MaxGen, cgcurve_GA)
    Problem.vm = 6; % Number of servers
    Problem.nVar = 10; % Number of tasks
    max_trials = 50; % Maximum number of trials without improvement before a scout bee is sent
    max_neighborhood_size = 100; % Maximum neighborhood size
    min_neighborhood_size = 10; % Minimum neighborhood size
    neighborhood_decay_rate = 0.9; % Rate of neighborhood size decay
    stagnation_threshold = 5; % Number of consecutive iterations with no improvement before applying diversification
    local_search_iterations = 3; % Number of iterations for local search

    % Initialize population
    population = BestChrom.Gene; % Random assignment of tasks to servers
    best_solution = population; % Initialize best solution
    best_fitness = objective_function(best_solution, Problem.vm, Problem.nVar); % Evaluate fitness of best solution

    % Initialize stagnation counter
    stagnation_counter = 0;

    % Initialize neighborhood size
    neighborhood_size = max_neighborhood_size;

    % Initialize convergence curve for HB
    cgcurve_HB = zeros(1, max_iterations + MaxGen);

    for iter = 1:max_iterations
        % Employed Bees Phase with dynamic neighborhood size and local search
        for i = 1:Problem.nVar
            for trial = 1:max_trials
                neighbor_solution = population;
                % Generate neighboring solution
                neighborhood_size_rounded = round(neighborhood_size);
                neighbor_solution(i) = mod(neighbor_solution(i) + randi([-neighborhood_size_rounded, neighborhood_size_rounded]), Problem.vm) + 1;
                % Perturb the neighbor solution randomly
                perturbation = randi([-1, 1], 1, Problem.nVar); % Random perturbation vector
                neighbor_solution = mod(neighbor_solution + perturbation, Problem.vm) + 1; % Apply perturbation
                % Evaluate fitness of neighboring solution
                neighbor_fitness = objective_function(neighbor_solution, Problem.vm, Problem.nVar);
                % Apply local search to the neighboring solution
                for ls_iter = 1:local_search_iterations
                    improved_solution = local_search(neighbor_solution, Problem, max_neighborhood_size);
                    improved_fitness = objective_function(improved_solution, Problem.vm, Problem.nVar);
                    % Update the neighboring solution if improvement is found
                    if improved_fitness > neighbor_fitness
                        neighbor_solution = improved_solution;
                        neighbor_fitness = improved_fitness;
                    else
                        break; % Break if no improvement is found in local search
                    end
                end
                % Update solution if it's better
                if neighbor_fitness > best_fitness
                    best_solution = neighbor_solution;
                    best_fitness = neighbor_fitness;
                    % Reset stagnation counter
                    stagnation_counter = 0;
                end
            end
        end

        % Scout Bees Phase
        if mod(iter, max_trials) == 0
            % Replace solutions with randomly generated ones
            population = randi([1, Problem.vm], 1, Problem.nVar);
        end

        % Increment stagnation counter if no improvement
        if iter > 1 && best_fitness == cgcurve_HB(iter - 1)
            stagnation_counter = stagnation_counter + 1;
        else
            stagnation_counter = 0; % Reset stagnation counter
        end

        % Apply diversification mechanism if stagnation threshold is reached
        if stagnation_counter >= stagnation_threshold
            % Adjust neighborhood size dynamically
            neighborhood_size = max(min_neighborhood_size, neighborhood_size * neighborhood_decay_rate);
            % Reset stagnation counter
            stagnation_counter = 0;
        end
        disp(['Iteration #', num2str(iter)]);
        cgcurve_HB(MaxGen+iter) = best_fitness;
    end
    disp('___________________________');
    disp('HYBRID ALGORITHM BEST CHROMOSOME: ');
    disp(best_solution);
    disp('BEST FITNESS:');
    disp(best_fitness);
    calload(best_solution, Problem);
    % Plotting convergence curves
    x_GA = 1:length(cgcurve_GA);
    x_HB = (MaxGen+1):(MaxGen+max_iterations);
    y_GA = cgcurve_GA;
    y_HB = cgcurve_HB(MaxGen+1:end);


    % Plotting the convergence curves of GA and HB on the same plot
    plot(x_GA, y_GA, 'r', x_HB, y_HB, 'b');
    xlabel('Iteration');
    ylabel('Fitness');
    title('Convergence Curves');
    legend('Genetic Algorithm', 'Hybrid Algorithm', 'Location', 'northwest');
end

function [improved_solution] = local_search(solution, Problem, max_neighborhood_size)
    % Perform local search to refine the solution
    improved_solution = solution;
    for i = 1:Problem.nVar
        for j = 1:max_neighborhood_size
            % Generate neighboring solution
            neighbor_solution = solution;
            neighbor_solution(i) = mod(neighbor_solution(i) + j, Problem.vm) + 1;
            % Evaluate fitness of neighboring solution
            neighbor_fitness = objective_function(neighbor_solution, Problem.vm, Problem.nVar);
            % Update solution if improvement is found
            if neighbor_fitness > objective_function(improved_solution, Problem.vm, Problem.nVar)
                improved_solution = neighbor_solution;
            else
                break; % Break if no improvement is found
            end
        end
    end
end

