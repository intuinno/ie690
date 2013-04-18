%% CODE for IE 690 Project!
% Written by Sriram Karthik Badam, Deok Gun Park
% based on the code examples provided in Chalearn 

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

%% == Choose an example ==
example_num=input('Movie example num [1, 2, or 3]: ');

% For each movie, we fetched the labels from train.csv and test.csv
if example_num==1
    batch_num=1;  movie_num=19; 
    train_labels=[10 7 4 2 8 1 6 9 3 5];
    test_labels=[10 2 3 3];
elseif example_num==2
	batch_num=3;  movie_num=16; 
    train_labels=[5 1 4 6 8 7 2 3];
    test_labels=[6 2 1 3];
else
    batch_num=15;  movie_num=24; 
    train_labels=[4 3 1 6 5 7 2 8];
    test_labels=[4];
end
data_name=sprintf('devel%02d', batch_num); 

% Load M and K movies... (fps is the number of frames per seconds)
fprintf('Loading movie, please wait...');
[K0, fps]=read_movie([data_dir '/' data_name  '_K_' num2str(movie_num) '.avi']); 
[M0, fps]=read_movie([data_dir '/' data_name  '_M_' num2str(movie_num) '.avi']); 
fprintf(' Done!\n\n');

%% ================== GET RID OF NOISE ======================================

K = remove_noise(K0);
play_movie(K);

%% ================== Find Edge Features ====================================

GRADIENT_THRESHOLD = 1;
for i = 1:length(K)
    %K(i).cdata = edge(rgb2gray(K(i).cdata),'canny');
    f =  im2double(rgb2gray(K(i).cdata));
    [Gx, Gy] = gradient(f);
    
    %find the pixels that can be edges
    [Ix, Iy] = find((Gx.^2 + Gy.^2).^(0.5) > GRADIENT_THRESHOLD);
    
end




