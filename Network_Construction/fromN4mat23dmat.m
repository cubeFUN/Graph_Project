function [out] = fromN4mat23dmat(tmp)
caseNum = length(tmp(:,1));
widthArr = unique(tmp(:,1));
heightArr = unique(tmp(:,2));
depthArr = unique(tmp(:,3));

width = length(widthArr);
height = length(heightArr);
depth = length(depthArr);

out = NaN(width+2, height+2, depth+2);

for idx = 1:caseNum
    xpos = find(widthArr == tmp(idx,1)) + 1;
    ypos = find(heightArr == tmp(idx,2)) + 1;
    zpos = find(depthArr == tmp(idx,3)) + 1;
    out(xpos,ypos,zpos) = tmp(idx, 4);

end
