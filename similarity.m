function probability  = similarity(T, P)
    % An alternative sort to speed up things!
    m = size(T,1); n = size(P,1);
    [c,p] = sortrows([T;P]);
    q = 1:m+n; q(p) = q;
    t = cumsum(p>m);
    r = 1:n; r(t(q(m+1:m+n))) = r;
    s = t(q(1:m));
    id = r(max(s,1));
    iu = r(min(s+1,n));
    %[prob,it] = max([-((((T(:, 1)-P(id, 1))./240).^2)/(2*sigmaX^2)+(((T(:, 2)-P(id, 2))./360).^2)/(2*sigmaY^2)) -((((P(iu, 1)-T(:, 1))./240).^2)/(2*sigmaX^2)+(((P(iu, 2)-T(:, 2))./360).^2)/(2*sigmaY^2))], [], 2);
    [prob,it] = max([-((((T(:, 1)-P(id, 1))./120).^2)/(2*sigmaX^2)+(((T(:, 2)-P(id, 2))./180).^2)/(2*sigmaY^2)) -((((P(iu, 1)-T(:, 1))./120).^2)/(2*sigmaX^2)+(((P(iu, 2)-T(:, 2))./180).^2)/(2*sigmaY^2))], [], 2);
    probability = sum(prob);
end

