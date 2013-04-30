function removeNoiseImage = removeNoise(I)

NUM_NOISE_THRESHOLD = 0.05;
NUM_NOISE_GRAD_THRESHOLD = 50;


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

Inoise = (gradmag > NUM_NOISE_GRAD_THRESHOLD) & (I < noiseIndex);
SE = strel('disk',1,0);
Inoise = imdilate(Inoise,SE);
Inoise = imfill(Inoise,'holes');
figure, imshow(Inoise);


[L num] = bwlabel(Inoise);

[B,L,N,A] = bwboundaries(Inoise,'noholes');
	


[row col] = find(Inoise);

Inoise2 = double(I);

for i=1:length(row)
	Inoise2(row(i),col(i)) = NaN;
end
figure, imshow(Inoise2);

Inoise3 = Inoise2;

while(find(isnan(Inoise3))) 
	Inoise3 = nlfilter(Inoise3, [3,3], @neighError);
%	figure, imshow(Inoise3);
end


Inoise4 = Inoise3(4:237, 4:317);

figure, imshow(uint8(Inoise4));

removeNoiseImage = Inoise4;

end
