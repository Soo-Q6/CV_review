function [A, inlineridxs,max_inliners] = est_optimal_homography_ransac(points1, points2, ntrials)
% estimate the fundamental matrix using two set of points
% using ransac to estimate the fundamental matrix

% points1-->points2

% check the input
if(any(size(points1) ~= size(points2)))
    error('The points should be given in pair!');
end
if(size(points1,2) == 2)
        points1 = [points1, ones(size(points1,1),1)];
end
if(size(points2,2) == 2)
        points2 = [points2, ones(size(points2,1),1)];
end
% get the number of points
N = size(points1,1);
if(N < 4)
    error('At least 4 points are required!');
end

% check the number of trials for fundamental
if(ntrials < 20)
    ntrials = 20;
end

% set the random state
seed = 1234;
RNDN_STATE = randn('state');  %#ok<*RAND>
randn('state', seed);
RND_STATE = rand('state');
rand('twister', seed);

% do the random experiments
inliners = cell(ntrials,2);
num_inliners = zeros(ntrials,1);
th_inliner = 20;
for i = 1 : ntrials
    % randomly picking 3 point
    y = randsample(N,4);
    
    % estimate the fundamental matrix
%     F = est_optimal_affine(points1(y,:), points2(y,:));
    F = estimate_H(points2(y,:), points1(y,:));
    inliners{i,1} = F;
    
%     if(abs(F(1,1)-0.94)<0.1 && abs(F(2,2)-0.96)<0.1 && abs(F(1,3)-626)<50 && abs(F(2,3)-310)<50)
%         inDebug = 1;
%     end
%     F=[0.9432 0.0851 626.1134;-0.0108 0.9631 310.9023];
    
    % get the inliner indexes
    L12 = homography_transform(F, points1);
    d = sqrt(sum((L12 - points2).^2,2));
    % d = diag(points2 * F * points1');
    inliners{i,2} = find(abs(d) < th_inliner);
    
    
    % get the number of inlines
    num_inliners(i) = length(inliners{i, 2});
end

% get the optimal solutions
[~,idx] = max(num_inliners);
max_inliners=num_inliners(idx);
A = inliners{idx,1};
inlineridxs = inliners{idx,2};
end


% estimate the homography matrix
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




