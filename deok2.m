	path = [];
	path2 = [];
	figure;
	for i= 1:length(all_features)
i
		numFrame = length(all_features(i).gesture)
		numFrameTest = length(movie_features); 
		prior = 1/numFrameTest * ones(numFrame,1);
		prior(1) = prior(1)*100;
		transmat = makeTransmat(numFrame, 0.55, 0.05, 0.4, 1);
		[path] = viterbi_path(prior, transmat, obsLik(i).B);
		

		subplot(3,4,i), plot(path);
		path2 = [path2; struct('Path',path)];	
	end
	
		figure;
	for i= 1:length(all_features)

		subplot(3,4,i), plot((obsLik(i).B)');

	end
	