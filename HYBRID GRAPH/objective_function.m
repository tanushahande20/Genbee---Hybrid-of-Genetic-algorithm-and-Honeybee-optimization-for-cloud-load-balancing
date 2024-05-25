function [fitness] = objective_function(solution, vm, nVar)
    ETC = [1, 27, 10, 17, 15, 2, 34, 12, 15, 45;
           27, 23, 41, 36, 27, 1,  6, 34, 23,  5;
           12, 17, 13, 31, 47, 37, 41, 27, 20, 17;
           36, 26, 16, 42,  4, 42, 34, 23, 45, 23;
           12,  3, 23,  8,  3,  9, 34, 18, 20, 19;
           29, 44,  8, 45, 11, 33, 47, 50,  1, 10];

    RCU = [12, 8, 10, 3, 18, 9];

    % Initialize CONV matrix
    CONV = zeros(vm, nVar);

    % Calculate CONV matrix
    for i = 1:nVar
        x = solution(i);
        CONV(x, i) = 1;
    end

    % Calculate sumTime for each server
    sumTime = zeros(1, vm);
    for i = 1:vm
        sumTime(i) = sum(ETC(i, :) .* CONV(i, :));
    end

    % Calculate totalTime
    totalTime = max(sumTime);

    % Calculate totalCost
    totalCost = sum(sumTime .* RCU);

    % Calculate fitness
    wt = 1; % Weight parameter
    Ft = 1 / totalTime;
    Fc = 1 / totalCost;
    fitness = wt * Ft + (1 - wt) * Fc;
end

