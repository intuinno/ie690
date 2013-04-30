close all
clear

load sampleMovie

NUM_DEPTH_THRESHOLD = 10;
NUM_NOISE_THRESHOLD = 0.05;
NUM_GRAD_THRESHOLD = 100;

%
colormap(jet);
I = K0(1).cdata(:,:,1);

I2 = I/NUM_DEPTH_THRESHOLD;
I3 = I2*NUM_DEPTH_THRESHOLD;

figure, imshow(I);

figure, imshow(I3), colormap('jet');






I4 = zeros(size(I));



for i =1:max(max(I2)) 
	temp = I2 == i;
	
	[B,L,N,A] = bwboundaries(temp,'noholes');
	

	for j=1:length(B)
		
		a = cell2mat(B(j));
		
		[m n] = size(a);
		
		for k = 1:m
			I4(a(k,1),a(k,2)) = i;
		end
		
		
	end
	
end

I5 = I4 * NUM_DEPTH_THRESHOLD;
figure, image(I5),colormap('jet');

%Appy Sobel to extract edge
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
figure, imshow(gradmag,[]), title('Gradient magnitude (gradmag)')


%Noise Identification 
sum = 0;
[m n] = size(I);
total = m *n;
for i = 0:255
	
	sum = sum + length(find(I == i)); 
	
	percentSum = sum/total;
	
	if percentSum > NUM_NOISE_THRESHOLD 
		noiseIndex = i;
		break;
	end
	
	
end

Inoise = (gradmag > 100) & (I < noiseIndex);
SE = strel('disk',1,0);
Inoise = imdialate(Inoise,SE);



figure, imshow(Inoise);



Inoise2 = immultiply(I,~Inoise) + uint8(Inoise*255);
figure, imshow(Inoise2);




	
	




		
		