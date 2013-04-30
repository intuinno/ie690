
function ret = neighError(x)

	[r c] = find(isnan(x));
	
	if length(r) > 0 
	
		hasNan = true;
	end
	
	
	if ~isnan(x(2,2))
		
		ret = x(2,2);
		
	elseif length(r) == 9
		
		ret = x(2,2);
		
	else
		
% 		if mean(r) - 2 > 0.3 
% 			
% 			rInd = 1;
% 			
% 		elseif mean(r) - 2 < -0.3
% 			
% 			rInd = 3;
% 			
% 		else
% 			
% 			rInd =2;
% 			
% 		end
% 		
% 		
% 		if mean(c) - 2 > 0.3 
% 			
% 			cInd = 1;
% 			
% 		elseif mean(c) - 2 < -0.3
% 			
% 			cInd = 3;
% 			
% 		else
% 			
% 			cInd =2;
% 			
% 		end
		
		[r2 c2] = find(~isnan(x));

		dist = 0;
		
		for i=1:length(r2) 
			
			dist2 = sqrt((r2(i) -mean(r))^2 + (c2(i)-mean(c))^2);
		
			if dist < dist2
				
				dist = dist2;
				
				rInd = r2(i);
				cInd = c2(i);
				
			end
			
			
		end
		
			
		ret = x(rInd,cInd);
		
	end
	
		
		

end

