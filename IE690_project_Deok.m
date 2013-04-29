close all
clear

load sampleMovie


%
colormap(jet);
I = K0(1).cdata(:,:,1);
I3 = double(I) /256.0;
figure, surf(I3) %, 'FaceColor','interp','EdgeColor','none','FaceLighting','phong')

B = reshape(I3,1,[]);
figure,hist((B),100);

%Appy Sobel to extract edge
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
figure, imshow(gradmag,[]), title('Gradient magnitude (gradmag)')

figure, BW1 = edge(I,'prewitt');
imshow(BW1);

figure, BW1 =  edge(I, 'canny');
imshow(BW1);

figure, BW1 = edge(I, 'zerocross');
imshow(BW1);

figure, BW1 = edge(I, 'log');
imshow(BW1);

figure, BW1 = edge(I,'roberts');
imshow(BW1);

figure, BW1 = edge(I,'sobel');
imshow(BW1);



