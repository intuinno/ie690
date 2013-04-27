	path = [];
	path2 = [];
	figure;
	for i= 1:length(all_features)
		i
		numFrame = length(all_features(i).gesture)
		numFrameTest = length(movie_features); 
		prior = 1/numFrameTest * ones(numFrame,1);
		priorFirst = 1/numFrameTest;
		prior3 = [priorFirst; prior];
		
		transmat = makeTransmat(numFrame+1, 0.9, 0.05, 0.05, 1);
		
		b = obsLik(i).B;
		
		c = [mean(b,1); b];
		
		[path] = viterbi_path(prior3, transmat, c)
		subplot(3,4,i), plot(path);
		path2 = [path2; struct('Path',path)];	
	end
	