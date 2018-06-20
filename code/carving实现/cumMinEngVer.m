function [Mx, Tbx] = cumMinEngVer(e)
% e is the energy map.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.

[ny,nx] = size(e);
Mx = zeros(ny, nx);
Tbx = zeros(ny, nx);
Mx(1,:) = e(1,:);

%% Add your code here
for i=2:ny
    if Mx(i-1,2)<Mx(i-1,1)
        Mx(i,1)=Mx(i-1,2)+e(i,1);
        Tbx(i,1)=1;
    else
        Mx(i,1)=Mx(i-1,1)+e(i,1);
        Tbx(i,1)=0;
    end
    for j=2:nx-1
        if Mx(i-1,j-1)==min(Mx(i-1,j-1:j+1))
            Mx(i,j)=Mx(i-1,j-1)+e(i,j);
            Tbx(i,j)=-1;
        elseif Mx(i-1,j)==min(Mx(i-1,j-1:j+1))
            Mx(i,j)=Mx(i-1,j)+e(i,j);
            Tbx(i,j)=0;
        else
            Mx(i,j)=Mx(i-1,j+1)+e(i,j);
            Tbx(i,j)=1;
        end
    end
    if Mx(i-1,nx)<Mx(i-1,nx-1)
        Mx(i,nx)=Mx(i-1,nx)+e(i,nx);
        Tbx(i,nx)=0;
    else 
        Mx(i,nx)=Mx(i-1,nx-1)+e(i,nx);
        Tbx(i,nx)=-1;
    end
end
end