

im1 = imread('z.jpg'); 



figure(1);clf; %imshow(im1);
[BW, xi, yi] = roipoly(im1);
save('cat.mat','BW','xi','yi');