function [fitness_value] = Fit(X, Problem)
    fitness_val = 0;
    CONV = zeros(Problem.vm, Problem.nVar);
    % Calculate CONV
    for i = 1: Problem.nVar
        x = X(i);
        CONV(x, i) = 1;
    end

    % Calculate sumTime
    sumTime = zeros(1, Problem.vm);
    for i = 1:Problem.vm
        for j = 1:Problem.nVar
            sumTime(i) = sumTime(i) + Problem.ETC(i, j) * CONV(i, j);
        end
    end

    % Calculate totalTime
    totalTime = max(sumTime);

    % Calculate cost
    cost = sumTime .* Problem.RCU;
    totalCost = 0;
    for i = 1:Problem.vm
        totalCost = totalCost + cost(i);
    end
    Ft = 1 / totalTime;
    Fc = 1 / totalCost;
    wt = 1;
    fitness_value = wt * Ft + (1 - wt) * Fc;
end

