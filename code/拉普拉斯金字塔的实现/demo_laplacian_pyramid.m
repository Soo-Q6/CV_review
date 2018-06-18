


im1 = imread('z.jpg'); 



nlvls = 4;
laps1 = genPyramids(im1,nlvls);


xsep = 2;
ysep = 0;
szIm = size(im1); 
if(size(im1,3) == 1) 
    szIm(3) = 1; 
end
gaussIm = ones(szIm(1), szIm(2) + size(laps1{2,1},2) + xsep * 2, szIm(3))*255;
gaussIm(1: szIm(1), 1 : szIm(2), :) = laps1{1,1};
top = 0; left = szIm(2) + xsep;
for i = 2 : nlvls
   sz4lvl = size(laps1{i,1});
   gaussIm( top + (1 : sz4lvl(1)),...
            left + (1 : sz4lvl(2)),...
            :) = laps1{i,1};
   top = top + ysep + sz4lvl(1);
end
figure(2);imshow(uint8(gaussIm));


lapIm = ones(szIm(1), szIm(2) + size(laps1{2,1},2) + xsep, szIm(3))*255;
lapIm(1: szIm(1), 1 : szIm(2), :) = laps1{1,2};
top = 0; left = szIm(2) + xsep;
for i = 2 : nlvls
   sz4lvl = size(laps1{i,1});
   lapIm( top + (1 : sz4lvl(1)),...
            left + (1 : sz4lvl(2)),...
            :) = laps1{i,2};
   top = top + ysep + sz4lvl(1);
end
figure(3);imshow(uint8(lapIm + 127));


imBlend=recoverLaplacian(laps1(:,2));
figure;
imshow(uint8(imBlend));