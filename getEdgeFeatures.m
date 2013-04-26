function [movie_features, EdgeX, EdgeY] = getEdgeFeatures(K0)

%% ================== GET RID OF NOISE ======================================

    %K = remove_noise(K0);
    K = K0;
    SE = ones(5);
    for i = 1:length(K)
        K(i).cdata(:, :, 1) = imdilate(K0(i).cdata(:, :, 1), SE);
        K(i).cdata(:, :, 2) = imdilate(K0(i).cdata(:, :, 1), SE);
        K(i).cdata(:, :, 3) = imdilate(K0(i).cdata(:, :, 1), SE);
    end

    %play_movie(K);


%% ================== Find Edge Features ====================================

    %thresholds should be dependent on histogram 
    THRESHOLD_FEATURE = 0.07;
    THRESHOLD_NOISE = 0.12;
    THRESHOLD_MAGNITUDE = 70;

    % preallocate
    Edges(1:length(K)) = struct('cdata',[], 'colormap',[]);
    EdgeX = [];
    EdgeY = [];
    
    movie_features = [];
    %feature = struct('gradient',{},'orientation',{});
    GRADIENT_THRESHOLD = 0.11;
    for i = 1:length(K)

        frame_features = []; 
        %K(i).cdata = edge(rgb2gray(K(i).cdata),'canny');

        image = rgb2gray(K(i).cdata);
        f =  im2double(rgb2gray(K(i).cdata));
        [Gx, Gy] = gradient(f);
        
        %Get foreground
        fgm = imregionalmin(image);
        %figure, imshow(fgm), title('Regional maxima of opening-closing by reconstruction (fgm)')
        %I2 = I;
        image(fgm) = 255;

        %find the pixels that can be edges
        %[Ix, Iy] = find((Gx.^2 + Gy.^2).^(0.5) > GRADIENT_THRESHOLD);

        %motion region
        motion = zeros(size(rgb2gray(K(1).cdata)));
        if (i>1)
            motion = (rgb2gray(K(1).cdata) - rgb2gray(K(i).cdata));    
        end

        %motion = imdilate(motion, ones(3));
        fgm = imregionalmin(motion);
        motion(fgm) = 0;
        fgm = find(motion<30);
        motion(fgm) = 0;
        % open and close to get rid of noise
        motion = imerode(motion, ones(3));
        motion = imdilate(motion, ones(3));
        motion = imerode(motion, ones(3));
        motion = imdilate(motion, ones(3));
        motion = imerode(motion, ones(3));
        motion = imdilate(motion, ones(3));
        motion = imdilate(motion, ones(5));
        [Mx, My] = find(motion);
        M = [Mx My]; 
        motion_bool = zeros(size(K(i).cdata(:, :, 1)));

        % remove the back ground noise using the gradient values
        %[Ix, Iy] = find(((Gx.^2 + Gy.^2).^(0.5) > THRESHOLD_FEATURE) - ((Gx.^2 + Gy.^2).^(0.5) > THRESHOLD_NOISE & K(i).cdata(:,:,1) < THRESHOLD_MAGNITUDE));
        [Px, Py] = find(((Gx.^2 + Gy.^2).^(0.5)> THRESHOLD_FEATURE));

        EdgeX = [EdgeX; Px];
        EdgeY = [EdgeY; Py];
        
        %Gt = (rgb2gray(K(i-1).cdata) - rgb2gray(K(i).cdata));

        L = size(Px);
        result = [Px Py];
        
        count = 0;
%         for j = 1:L
%             feature  = struct('x', Px(j), 'y', Py(j), 'gradient', (Gx(Px(j),Py(j))^2 +  Gy(Px(j),Py(j))^2)^0.5, 'orientation', atan(Gy(Px(j),Py(j))/Gx(Px(j),Py(j))), 'magnitude', K(i).cdata(Px(j),Py(j)), 'motion', ismember([Px(j) Py(j)], M, 'rows'));
%             frame_features = [frame_features; feature];
%             if (ismember([Px(j) Py(j)], M, 'rows'))
%                 count= count+1;
%                 motion_bool(Px(j),Py(j)) = 1;
%             end
%         end
        
        
        %fprintf('motion edge points = %d \n', count); 

        %figure 
        %imshow(motion_bool);
        %figure
        %imshow(motion);

        %movie_features = [movie_features, struct('frame', frame_features)];
        movie_features = [movie_features, struct('frame', result)];
        
        Edges(i).cdata = (Gx.^2 + Gy.^2).^(0.5)> THRESHOLD_FEATURE;
        %figure 
        %imshow(Edges(i).cdata);
end

