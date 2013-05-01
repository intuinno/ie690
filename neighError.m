
function ret = neighError(x)

	
	

	
	
	if ~isnan(x(2,2))
		
		ret = x(2,2);
		

		
	else
		
% 	
		[r c] = find(isnan(x));
		[r2 c2] = find(~isnan(x));
        
        if length(r) == 9 
            
            ret = x(2,2);
            
        else 

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
	
		
		

end
