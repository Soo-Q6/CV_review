function [Ix, E, rmIdx] = rmVerSeam(I, Mx, Tbx)
% I is the image. Note that I could be color or grayscale image.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.
% Ix is the image removed one column.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx = zeros(ny, 1);
Ix = uint8(zeros(ny, nx-1, nz));

%% Add your code here
I_tmp=I;
E=min(Mx(ny,:));
tmp=find(Mx(ny,:)==E);
rmIdx(ny)=tmp(1);
rmIdx(ny-1)=rmIdx(ny)+Tbx(ny,rmIdx(ny));
for i=ny-1:-1:2
    rmIdx(i-1)=rmIdx(i)+Tbx(i,rmIdx(i));
end
for i=1:ny
    I(i,rmIdx(i))=0;
    for j=rmIdx(i):nx-1
        I_tmp(i,j,:)=I_tmp(i,j+1,:);
    end
end
Ix=I_tmp(:,1:nx-1,:);
end