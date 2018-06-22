% estimate the homography matrix

% grids=[vx vy 1];共n中点
% u=[ux uy 1];
function H = estimate_H(u, grids)
    % check the grids
    if(size(grids,2) == 2)
        grids = [grids, ones(size(grids,1),1)];
    else
        if(size(grids,2) == 3)
        else
            error('The grids should be in Nx2 or Nx3 format!');
        end
    end
    % get the matrix for matching
    M = fill_M4H(u, grids);
    % M指的是计算单应矩阵所需要的矩阵，即null(M)
    
    
    
    MtM = M' * M;
    [v, ~] = eigs(MtM, 1, 'sa');
   
    % do the estimation
    H = reshape(v,[3,3]); H = H';
   
    % check the sign
    uhat = H * grids';
    zhat = mean(uhat(3,:));
    if(zhat<0)
        H = -H;
    end
    
% fill the matrix for the homography
function M = fill_M4H(u, grids)
    np = size(u,1);
    M = zeros(np*2, 9); % allocate memory for estimating H
   
    % check the grids
    if(size(grids,2) == 2)
        grids = [grids, ones(np,1)];
    else
        if(size(grids,2) == 3)
        else
            error('The grids should be in Nx2 or Nx3 format!');
        end
    end
   
    z3 = zeros(1,3);
    for i = 1 : np
        M(2*i-1, :) = [grids(i,:) z3 -u(i,1).*grids(i,:)];
        M(2*i  , :) = [z3 grids(i,:) -u(i,2).*grids(i,:)];
    end
end
    H = H./(H(3,3)+1e-20);
end

