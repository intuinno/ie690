function removeNoiseImage = removeNoise(I)

NUM_NOISE_THRESHOLD = 0.05;
NUM_NOISE_GRAD_THRESHOLD = 100;


%Appy Sobel to extract edge
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
%figure, image(gradmag,[]), title('Gradient magnitude (gradmag)')


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
%figure, image(Inoise*255);


[L num] = bwlabel(Inoise);

[B,L,N,A] = bwboundaries(Inoise,'noholes');
	


[row col] = find(Inoise);

Inoise2 = double(I);

for i=1:length(row)
	Inoise2(row(i),col(i)) = NaN;
end
%figure, imshow(Inoise2);

Inoise3 = Inoise2;
%h = figure;
while(find(isnan(Inoise3))) 
	Inoise3 = nlfilter(Inoise3, [3,3], @neighError);
 %   image(Inoise3);
end
%close(h);
for i = 1:m 
	
	if Inoise3(i,1) < 10 
		
		j = 1;
		while (Inoise3(i,j ) <10 )
			j = j + 1;
		end
		
		for k = 1:j
			
			Inoise3(i,k) = Inoise3(i,j);
			
		end
		
	end
	
	if Inoise3(i, n) <10 
		
		j=1;
		while(Inoise3(i,n-j) <10) 
			j= j+1;
		end
		
		for k=1:j
			Inoise3(i,n+1-k) = Inoise3(i, n-j);
		end
		
	end
	
end


for i = 1:n 
	
	if Inoise3(1,i) < 10 
		
		j = 1;
		while (Inoise3(j,i ) <10 )
			j = j + 1;
		end
		
		for k = 1:j
			
			Inoise3(k,i) = Inoise3(j,i);
			
		end
		
	end
	
	if Inoise3(m, i) <10 
		
		j=1;
		while(Inoise3(m-j,i) <10) 
			j= j+1;
		end
		
		for k=1:j
			Inoise3(m+1-k,i) = Inoise3(m-j,i);
		end
		
	end
	
end



%figure, imshow(uint8(Inoise3));

removeNoiseImage = Inoise3;

end
