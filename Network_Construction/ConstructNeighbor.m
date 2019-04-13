function valueNearby = ConstructNeighbor(imageWithROI,map)
	
	box_len = 3;
	seq = [-1,0,1];
	mask = zeros(box_len^3,3);
	for i = 0:box_len^3-1
		a = rem(i,box_len) + 1;
		b = floor((i - floor(i / box_len^2)*box_len^2)/box_len) + 1;
		c = floor(i/box_len^2) + 1;
		mask(i+1,:) = [seq(c),seq(b),seq(a)];
	end
	
	[width,height,depth]=size(imageWithROI);
	valueNearby = cell(width,height,depth);
	for i = 1:width
		for j = 1:height
			for k = 1:depth
				if (~isnan(imageWithROI(i,j,k)) && (imageWithROI(i,j,k)~=0))
                    cur_idx = map(i,j,k);
                    tmp = nan(1,box_len^3);
					for nb_idx = 1:length(mask)
						ii = i+(mask(nb_idx,1));
						jj = j+(mask(nb_idx,2));
						kk = k+(mask(nb_idx,3));
						if (~(ii>=1 && ii<=width && jj>=1 && jj<=height && kk>=1 && kk<=depth))
							continue;
						end
						tmp(nb_idx) = imageWithROI(ii,jj,kk);
					end
					valueNearby{i,j,k} = tmp;
				end
			end
			
		end		
	end


end