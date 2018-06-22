function [My, Tby] = cumMinEngHor(e)
% e is the energy map.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.

[ny,nx] = size(e);
My = zeros(ny, nx);
Tby = zeros(ny, nx);
My(:,1) = e(:,1);

%% Add your code here
for i=2:nx
    if e(2,i-1)<e(1,i-1)
        My(1,i)=My(2,i-1)+e(1,i);
        Tby(1,i)=1;
    else
        My(1,i)=My(1,i-1)+e(1,i);
        Tby(1,i)=0;
    end
    for j=2:ny-1
        if e(j-1,i-1)==min(e(j-1:j+1,i-1))
            My(j,i)=My(j-1,i-1)+e(j,i);
            Tby(j,i)=-1;            
        elseif e(j,i-1)==min(e(j-1:j+1,i-1))
            My(j,i)=My(j,i-1)+e(j,i);
            Tby(j,i)=0;
        else
            My(j,i)=My(j+1,i-1)+e(j,i);
            Tby(j,i)=1;
        end
    end
    if e(ny,i-1)<e(ny-1,i-1)
        My(ny,i)=My(ny,i-1)+e(ny,i);
        Tby(ny,i)=0;
    else
        My(ny,i)=My(ny-1,i-1)+e(ny,i);
        Tby(ny,i)=-1;
    end
end
end