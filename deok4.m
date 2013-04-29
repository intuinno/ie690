close all
clear

load sampleMovie

NUM_DEPTH_THRESHOLD = 20;

%
colormap(jet);
I = K0(1).cdata(:,:,1);

I2 = I/NUM_DEPTH_THRESHOLD;
I3 = I2*NUM_DEPTH_THRESHOLD;

figure, imshow(I);

figure, imshow(I3), colormap('jet');


I4 = I3 == 20;
figure,imshow(I4);
[B, L, N, A] = bwboundaries(I4,'noholes');

numSegment = 256/NUM_DEPTH_THRESHOLD;





