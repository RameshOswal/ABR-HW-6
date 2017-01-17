function [ U, n_components, lm ] = UpdateComponents( U, n_components, lm, l, s )
    if lm(s) == 0
        lm(s) = l;
    else
        c1 = find(U(:,l));  % the component that contains l
        c2 = find(U(:,lm(s)));  % the component that contains s
        if c1 ~= c2
           U(min(c1,c2), :) = U(c1, :) + U(c2, :);
           U(max(c1,c2):end-1, :) = U(max(c1,c2)+1:end,:);
           U(end,:) = 0;
           n_components = n_components - 1;
        end
    end
end