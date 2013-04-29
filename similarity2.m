function probability  = similarity2(T, P)
    prob = 0;
    for i = 1:length(T) 
       [max,index] = max(-((P(:, 1) - T(i, 1)./120).^2)/(2*sigmaX^2) + ((P(:, 2) - T(i,2)./180).^2)/(2*sigmaY^2));   
        prob = prob + max;
    end
    
    %[prob,it] = max([-((((T(:, 1)-P(id, 1))./120).^2)/(2*sigmaX^2)+(((T(:, 2)-P(id, 2))./180).^2)/(2*sigmaY^2)) -((((P(iu, 1)-T(:, 1))./120).^2)/(2*sigmaX^2)+(((P(iu, 2)-T(:, 2))./180).^2)/(2*sigmaY^2))], [], 2);
    probability = prob;
end
