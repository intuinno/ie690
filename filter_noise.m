function IM = filter_noise(IM)
%remove noise from a frame 
% One channel only
image = IM(:, :, 1);
[L, C]=size(image);

back_max = 255;
% max out the zeros because same are in the background

%image(image==0)=(back_max+1)/2-1;
NOISE_THRESHOLD = 50;

[X,Y] = find(image>NOISE_THRESHOLD);
for i=1:L
    for j = 1:C
        if (image(i, j) < NOISE_THRESHOLD) 
            A = (((X - i).^2 + (Y-j).^2).^(0.5));
            [offset, offsetid] = min(A);
            image(i, j) = image(X(offsetid), Y(offsetid));
        end
    end
end


IM(:, :, 1) = medfilt2(image);
IM(:, :, 2) = medfilt2(image);
IM(:, :, 3) = medfilt2(image);

end

