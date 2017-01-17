function [L, n_queries] = LandmarkSelection(q, iter, S)
% Complete the LandmarkSelection algorithm here.
    rng(0)
    n_queries = 0;
    iter = floor(iter);
    q = floor(q);
    L = zeros(iter, 1);
	
    % Choose l in S uniformly at random;
    n = size(S, 1);
    l = randi(n);
	L(1) = l;
    [d_min, new_queries] = query(l, S);
    n_queries = n_queries + new_queries;
	
    for i = 1:(iter-1)
		% FILL IN HERE
   [s,indx] = sort(d_min);
      pts = indx(n-q+1:n);
      l = pts(randi(q))
      L(i+1) = l;
      [d_min_new, new_queries] = query(l, S);
      n_queries = n_queries + new_queries;
      for j = 1:length(d_min)
          if(d_min_new(j)<d_min(j))
              d_min(j)= d_min_new(j);
          end
      end
	end
end