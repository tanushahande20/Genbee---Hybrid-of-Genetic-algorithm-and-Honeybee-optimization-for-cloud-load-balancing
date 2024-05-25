
function [child] = mutation(child, Pm, Problem)

Gene_no = length(child.Gene);

for k = 1: Gene_no
    R = rand();
    if R < Pm
        C = randi([1, Problem.vm]);
        child.Gene(k) = C;
    end
end

end
