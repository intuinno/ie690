function transmat = makeTransmat(numFrame, pNext, pLoop, pSkip, numSkip) 

m = numFrame; 

transmat = zeros(m);

transmat(1,1) = 0.99;
transmat(1,2) = 0.01;
transmat(m,m) = 1-pNext;

transmat(m,1) = pNext; 

for i = 2:m-1 
	transmat(i,i) = pLoop;
	transmat(i,i+1) = pNext;
	
	for j=1:numSkip
		
		if (i + j+1) < m 
			
			transmat(i,i+1+j) = pSkip * (0.5)^j;
		end
		
	end
	
	if (i+2+numSkip) < m
		transmat(i,i+2+numSkip) = pSkip * (0.5)^(numSkip);
	else 
		transmat(i,m) = 1 - sum( transmat(i,1:m-1));
	end
	
end


end
