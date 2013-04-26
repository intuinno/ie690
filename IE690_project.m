%% CODE for IE 690 Project!
% Written by Sriram Karthik Badam, Deok Gun Park
% based on the code examples provided in Chalearn 

clear;
clc;
    
if ~exist('this_dir')
    this_dir=pwd;
end
 
data_path   = [this_dir '/Examples/'];    % Path to the sample data.
data_dir    = [data_path '/devel/'];    % Path to the sample data.
code_dir    = this_dir; % Path to the code.
   
% Add the path to the function library
warning off; 
addpath(genpath(code_dir)); 
warning on;

%% ================== BEGIN LOADING DATA ======================================

%Choose an example
example_num=input('Movie example num [1, 2, 3 or 4 for the entire training dataset or 5 for testing the validation data]: ');
training = 0;
validation = 0;

% For each movie, we fetched the labels from train.csv and test.csv
if example_num==1
    batch_num=1;  movie_num=19; 
    train_labels=[10 7 4 2 8 1 6 9 3 5];
    test_labels=[10 2 3 3];
    data_name=sprintf('devel%02d', batch_num);
    % Load M and K movies... (fps is the number of frames per seconds)
    fprintf('Loading movie, please wait...');
    [K0, fps]=read_movie([data_dir '/' data_name  '_K_' num2str(movie_num) '.avi']); 
    [M0, fps]=read_movie([data_dir '/' data_name  '_M_' num2str(movie_num) '.avi']); 
    fprintf(' Done!\n\n');
    movie_features = getEdgeFeatures(K0);

elseif example_num==2
	batch_num=3;  movie_num=16; 
    train_labels=[5 1 4 6 8 7 2 3];
    test_labels=[6 2 1 3];
    data_name=sprintf('devel%02d', batch_num);
    % Load M and K movies... (fps is the number of frames per seconds)
    fprintf('Loading movie, please wait...');
    [K0, fps]=read_movie([data_dir '/' data_name  '_K_' num2str(movie_num) '.avi']); 
    [M0, fps]=read_movie([data_dir '/' data_name  '_M_' num2str(movie_num) '.avi']); 
    fprintf(' Done!\n\n');
    movie_features = getEdgeFeatures(K0);

elseif example_num==3
    batch_num=15;  movie_num=24; 
    train_labels=[4 3 1 6 5 7 2 8];
    test_labels=[4];
    data_name=sprintf('devel%02d', batch_num); 
    % Load M and K movies... (fps is the number of frames per seconds)
    fprintf('Loading movie, please wait...');
    [K0, fps]=read_movie([data_dir '/' data_name  '_K_' num2str(movie_num) '.avi']); 
    [M0, fps]=read_movie([data_dir '/' data_name  '_M_' num2str(movie_num) '.avi']); 
    fprintf(' Done!\n\n');
    movie_features = getEdgeFeatures(K0);

elseif example_num==4
    data_path   = ['devel-1-20_valid-1-20'];    % Path to the sample data.
    data_dir    = [data_path '/devel'];    % Path to the sample data.
    code_dir    = this_dir;
    training = 1;
    
elseif example_num==5
    %Validation set
    validation = 1;
    data_path   = ['devel-1-20_valid-1-20'];    % Path to the sample data.
    data_dir    = [data_path '/devel'];    % Path to the sample data.
    code_dir    = this_dir;
end

%% ======================= get features and build HMM =======================

hmm = [];
all_features = [];

edgeX = [];
edgeY = [];
if training == 1
    for i = 1:1
        if i < 10
            data_dir = [data_path '/devel0' num2str(i) '/'];
        else 
            data_dir = [data_path '/devel' num2str(i) '/'];
        end
        for j = 1:10
            data_name=sprintf('K_%d', j); 
            % Load M and K movies... (fps is the number of frames per seconds)
            fprintf('Loading movie, please wait... %s\n', [data_dir data_name '.avi']);
            [K0, fps]=read_movie([data_dir data_name '.avi']); 
            %[M0, fps]=read_movie([data_dir '/' data_name  '_M_' num2str(movie_num) '.avi']); 
            
            [movie_features, edge1, edge2] = getEdgeFeatures(K0);
            edgeX = [edgeX; edge1];
            edgeY = [edgeY; edge2];
            all_features = [all_features; struct('gesture', movie_features)];
            fprintf(' Done!\n\n');
            
            %hmm
            number_of_states = length(K0);
            TRANS = 0.2*eye(number_of_states);
            for i = 1:number_of_states
                if i < number_of_states
                    TRANS(i, i+1) = 0.8;
                end
            end

            EMIS = zeros(length(movie_features));
            for i = 1:length(movie_features)
                EMIS(i) = i;
            end
            
            hmm = [hmm; struct('EMIS', EMIS, 'TRANS', TRANS)]; 
            %[TRANS_EST, EMIS_EST] = hmmestimate(seq, states);
            
            
        end
    end

% find variance of edgeX, edgeY
sigmaX = var(edgeX./120 - 1)^0.5;
sigmaY = var(edgeY./180 - 1)^0.5;    
end



%% ======================= generative model =================================

if validation == 1
    load('features1.mat');
    load('hmm.mat');
    data_dir = [data_path '/devel01/'];
    data_name=sprintf('K_%d', 12); 
    % Load M and K movies... (fps is the number of frames per seconds)
    fprintf('Loading movie, please wait... %s\n', [data_dir data_name '.avi']);
    [K0, fps]=read_movie([data_dir data_name '.avi']); 
           
    %get the features in the testing set
    movie_features = getEdgeFeatures(K0);
    fprintf(' Done!\n\n');
    
    obsLik = [];
    
    %the index of the gesture and frame that the test frame corresponds to. 
    training_gesture_index = zeros(length(movie_features));
    training_frame_index = zeros(length(movie_features));    
    global_prob = 1;
    max_global = -Inf;
    
    for i= 1:length(all_features)
       B = zeros(length(all_features(i).gesture) ,length(movie_features));
       fprintf('Gesture %d\n', i);
             
       for frame=1:length(movie_features)
        %max_global = -Inf;

            T = movie_features(frame).frame;
            
            for j=1:length(all_features(i).gesture)                
                % edge points in a frame
                P = all_features(i).gesture(j).frame;    

                % An alternative sort to speed up things!
                m = size(T,1); n = size(P,1);
                [c,p] = sortrows([T;P]);
                q = 1:m+n; q(p) = q;
                t = cumsum(p>m);
                r = 1:n; r(t(q(m+1:m+n))) = r;
                s = t(q(1:m));
                id = r(max(s,1));
                iu = r(min(s+1,n));
                [prob,it] = max([-((((T(:, 1)-P(id, 1))./240).^2)/(2*sigmaX^2)+(((T(:, 2)-P(id, 2))./360).^2)/(2*sigmaY^2)) -((((P(iu, 1)-T(:, 1))./240).^2)/(2*sigmaX^2)+(((P(iu, 2)-T(:, 2))./360).^2)/(2*sigmaY^2))], [], 2);

                local_prob = sum(prob);

                % update B -- the emission matrix
                B(j, frame) = exp(sum(prob));

                % get the best match
%                 global_prob = local_prob;
%                 if max_global < global_prob
%                     max_global = global_prob;
%                     training_gesture_index(frame) = i;
%                     training_frame_index(frame) = j;
%                 end
            end
	   end
	   
	   
       obsLik = [obsLik; struct('B', B)];
            %fprintf('matched Gesture %d\t',training_gesture_index(frame));
            %fprintf('Frame %d with probability %f\n',training_frame_index(frame),max_global);
	end

	path = [];
	path2 = [];
	for i= 1:length(all_features)
		
		i
		
		numFrame = length(all_features(i).gesture)
		
		numFrameTest  =length(movie_features); 
		
		
		prior = 1/numFrameTest * ones(numFrame,1);
		transmat = makeTransmat(numFrame,0.5, 0.2, 0.3, 3);
		
		[path] = viterbi_path(prior, transmat, obsLik(i).B)
		
		path2 = [path2; struct('Path',path)];
		
		
	end
	
end



