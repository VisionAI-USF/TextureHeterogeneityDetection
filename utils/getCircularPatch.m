function patch = getCircularPatch(I,x,y,r)

[yIdx,xIdx]=meshgrid(1:size(I,1),1:size(I,2));
patch=(((xIdx-x).^2+(yIdx-y).^2)<=r^2);