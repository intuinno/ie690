function resu = test(this, data)
%resu = test(this, data)
% Make predictions with a recog_template method.
% Inputs:
% this -- A preprocessing object.
% data -- A data structure.
% Returns:
% resu -- A result data structure. WARNING: this follows the convention of
% Spider http://www.kyb.mpg.de/bs/people/spider/ *** The result is in resu.X!!!! ***
% resu.Y are the target values.

% Isabelle Guyon -- October 2011 -- isabelle@clopinet.com

if this.verbosity>0, fprintf('\n==TE> Testing %s for movie type %s... ', class(this), this.movie_type); end

resu=result(data);

% Loop over the samples (we also test the training samples)
% You don't need to re-write this method, you can use it "as is" and just
% customize the method "exec".
% The only thind to be careful about is maybe to test the type of data to
% see whether it is compatible with the preprocessing chosen.
Nte=length(data);
for k=1:Nte
    if this.verbosity>0,
        if ~mod(k, round(Nte/10))
            fprintf('%d%% ', round(k/Nte*100));
        end
    end
    [X, cuts]=exec(this, get_X(data, k), get_cuts(data, k));
    set_X(resu, k, X);
    set_cuts(resu, k, cuts);
end

if this.verbosity>0, fprintf('\n==TE> Done testing %s for movie type %s... ', class(this), this.movie_type); end
