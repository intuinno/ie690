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


%Opening 
se = strel('disk', 10);
Io = imopen(I, se);
figure, imshow(Io), title('Opening (Io)')


%Closing
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
figure, imshow(Iobr), title('Opening-by-reconstruction (Iobr)')

Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure, imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')


I = Iobrcbr;

hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
figure, imshow(gradmag,[]), title('Gradient magnitude (gradmag)')

