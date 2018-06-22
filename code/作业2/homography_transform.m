function y = homography_transform(A, x)
% the affine transform for the given points
if(size(x,2) ~= 3)
    error('The input x should be in N*3 format!');
end

if(size(A,1) ~= 3 || size(A,2) ~= 3)
    error('The input A should be in 3 x 3 format!');
end

y = A * x';
for i=1:size(y,2)
    y(:,i)=y(:,i)/y(3,i);
end

y = y';

end
