function [Iy, E, rmIdx] = rmHorSeam(I, My, Tby)
% I is the image. Note that I could be color or grayscale image.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.
% Iy is the image removed one row.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx = zeros(1, nx);
Iy = uint8(zeros(ny-1, nx, nz));

%% Add your code here
I_tmp=I;
E=min(My(:,nx));
rmIdx(nx)=find(My(:,nx)==E);
rmIdx(nx-1)=rmIdx(nx)+Tby(rmIdx(nx),nx);
for i=nx-1:2
    rmIdx(i-1)=rmIdx(i)+Tby(rmIdx(i),i);
end
for i=1:nx
    for j=rmIdx(i):ny-1
        I_tmp(j,i,:)=I_tmp(j+1,i,:);
    end
end
Iy=I_tmp(1:ny-1,:);
end