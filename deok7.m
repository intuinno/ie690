function features = 


NUM_DEPTH_THRESHOLD = 10;
NUM_NOISE_THRESHOLD = 0.05;



%
colormap(jet);


I = removeNoise(I);

I = removeNoise(I);

I2 = I/NUM_DEPTH_THRESHOLD;
I3 = I2*NUM_DEPTH_THRESHOLD;

figure, subplot(1,2,1), image(I), colormap(jet(256));

% figure, imshow(I3), colormap('jet');
% 
% figure, imhist(I);


I4 = double(I/256);



[BW thresh] = edge(I4, 'canny',[0.014, 0.3]);

% figure, imshow(BW), title('canny');


% 
% [BW thresh] = edge(I4, 'sobel');
% 
% figure, imshow(BW),title('sobel');


% 
% [BW thresh] = edge(I4, 'prewitt');
% 
% figure, imshow(BW),title('prewitt');
% 
% 
% 
% [BW thresh] = edge(I4, 'log');
% 
% figure, imshow(BW),title('log');
% 


level = graythresh(I4);

I4( find(I4 > level) ) = 1; 



BW2 = im2bw(I4, level);

[L num] = bwlabel (~BW2,8);

for i=1:num
	
	if  length( find(L == i) ) < 100 
		
		BW2( find(L ==i) ) = 1;
		
	end
	
end

SE = strel('disk',3,0);
BW3 = imdilate(~BW2,SE);

BW4 = BW & BW3; 

% figure, imshow( BW4);


[L num] = bwlabel (BW4,8);

for i=1:num
	
	if  length( find(L == i) ) < 10 
		
		BW4( find(L ==i) ) = 0;
		
	end
	
end

subplot(1,2,2), image( BW4*255), title(num2str(frameNum));

end
