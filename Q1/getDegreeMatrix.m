function D = getDegreeMatrix(W)
    % Calculates the Degree Matrix for a given adjacency matrix
	D = zeros(size(W, 1), size(W, 2));
        for i=1:length(W)
            D(i,i) = sum(W(i,:));
        end
    % Fill in D here
end