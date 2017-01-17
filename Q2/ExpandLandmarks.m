function [idxs, n_queries, flag] = ExpandLandmarks(k, s_min, n_prime, L, S)
% k - number of clusters to find
% s_min - the minimum number of points in each ball
% n_prime - the minimum number of points to be clustered
% L - landmarks
% S - nxp data matrix
% Returns:
% idxs - nx1 list of cluster ids for each point
% n_queries - scalar number of pairwise distances queried
% flag - boolean value, non-zero indicates failure to find a clustering.


    idxs = []; % Cluster ids for each point
    n_queries = 0;  % Number of pairwise distances calculated
    flag = 1;   % 0 = Success, 1 = Failure.
    n_samples = size(S, 1);
    n_landmarks = size(L,1);
    lm = zeros(n_samples, 1);  % Holds the index of the representative landmark for each data point
    items = zeros(n_landmarks, n_samples);  % data points in each ball about each landmark
    Clustered = zeros(n_samples, 1); % set of assigned points
    U = zeros(n_samples, n_samples); % set of sets of connected components in Gb
    n_components = 0;   % Tracks the number of connected components
    
    H = MinHeap(n_samples*n_landmarks);
    % Fill the heap with all the pairwise distances between landmarks and
    % samples
    for i = 1:n_samples
       for j = 1:n_landmarks
           l = L(j);
           dist = norm(S(l,:) - S(i,:));
           key = struct('val', dist, 'landmark_index', l, 's_index', i);
           n_queries = n_queries + 1;
           H.InsertKey(key);
       end
    end

    while H.Count() > 0
        x = H.ExtractMin();
        l_star = x.landmark_index;
        s_star = x.s_index;
        items(l_star, s_star) = 1;
        points_in_cur_ball = items(l_star, :);
        n_points_in_cur_ball = sum(points_in_cur_ball);
        %%% FILL IN HERE
                  if(n_points_in_cur_ball>s_min)
               %[ U, n_components, lm ] = UpdateComponents( U, n_components, lm, l, s )
               [U,n_components,lm] = UpdateComponents(U,n_components,lm,l_star,s_star);
               Clustered(s_star)=1;
           end
           if (n_points_in_cur_ball==s_min)
               for i = 1:size(U,1)
                   if sum(U(i,:)) == 0
                       U(i,l_star) = 1;
                       break;
                   end
               end
                Clustered(l_star) = 1;
           lm(l_star) = l_star;
           n_components = n_components+1;
               for i =1:length(items(l_star,:))
                   if(items(l_star,i)==1)
                       [U,n_components,lm] = UpdateComponents(U,n_components,lm,l_star,i);
                       Clustered(i)=1;
                   end
               end
           end
        %%%
        num_clustered = sum(Clustered);
        if num_clustered >= n_prime && n_components == k
            [idxs, flag] = FormatClustering(U, items);
            break;
        end
    end
end

