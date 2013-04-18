function M = remove_noise(M)
%Takes a movie as input and removes noise in each frame of the movie
    for k=1:length(M)
        frame=M(k).cdata;
        fprintf('frame %d\n',k);
        M(k).cdata = filter_noise(frame);
    end
end

