function [calload] = calload(Gene, Problem)
    CONV = zeros(Problem.vm, Problem.nVar);

    % Calculate CONV
    for i = 1: Problem.nVar
        x = Gene(i);
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

    mvm = 1/(Problem.vm - 1);
    tots = 0; % Initialize tots outside the loop
    for k = 1:Problem.vm
        avgTime = sumTime(k)/totalTime;
        tots = tots + (sumTime(k) - avgTime)^2; % Accumulate tots
    end
    calload = sqrt(mvm * tots);
    disp('LOAD ON VMS:')
    disp(calload);
    disp('___________________________');
end

