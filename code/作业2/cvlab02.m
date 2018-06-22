% cvlab02.m
clear;clc;close all
% %% 获取两幅图像
im1 = imread('pic3.jpg');
im2 = imread('pic4.jpg');
%im1 = imread('pic1.jpg');
%im2 = imread('pic2.jpg');
im1=imresize(im1,0.2);
im2=imresize(im2,0.2);
% im1=imrotate(im1,90);
% im2=imrotate(im2,90);
figure(1);imshow(cat(2, im1,im2));
% imwrite(rgb2gray(im1),'mydesk2_gray.png');
% imwrite(rgb2gray(im2),'mydesk3_gray.png');
img1=double(rgb2gray(im1))/256;
img2=double(rgb2gray(im2))/256;
%% Harris角点特征
% [Locs1,cornerness1] = detHarrisCorners(im1,0.1);
% [Locs2,cornerness2] = detHarrisCorners(im2,0.1);
% % 提取图像的特征，为NCC服务
% desc1 = extractNccFeature(im1, Locs1, 20);
% desc2 = extractNccFeature(im2, Locs2, 20);

% SURF特征
points1=detectSURFFeatures(img1);
points1=points1.selectStrongest(100);
points2=detectSURFFeatures(img2);
points2=points2.selectStrongest(100);
Locs1=points1.Location;
Locs2=points2.Location;
 [desc1, vpts1] = extractFeatures(img1, points1, 'Upright', true);  
[desc2, vpts2] = extractFeatures(img2, points2, 'Upright', true);  
% 进行特征的匹配
dist = desc1 * desc2';

% 选择特征
[vals, idxs] = max(dist,[], 2);
threshold = 0.85;
idxs1 = find(vals>threshold);
idxs2 = idxs(idxs1);
Locs1 = Locs1(idxs1,:);

% 绘制匹配点
figure(1);clf; imshow(cat(2, im1,im2)); hold on;
plot(Locs1(:,1),Locs1(:,2), 'ro', 'markersize',10);
plot(Locs2(idxs2,1)+size(im1,2), Locs2(idxs2,2), 'gx','markersize',10);

% for i = 1 : size(Locs1,1)
%    plot([Locs1(i,1), Locs2(idxs2(i),1)+size(im1,2)],...
%         [Locs1(i,2), Locs2(idxs2(i),2)], 'r-');
% end
% 保存图像
cdata = print('-RGBImage');
imwrite(cdata, 'harris2img_raw.png');
im1g = rgb2gray(im1); im1g = imresize(im1g,0.15);
im2g = rgb2gray(im2); im2g = imresize(im2g,0.15);

%%
% load cv0528.mat
% imshow(cdata);
% 用Ransac估计仿射变换
ntrials = 10000;
 [A, inlineridxs,max_inliners] = est_optimal_homography_ransac(Locs2(idxs2,:), Locs1,  ntrials);
%  save cvlab02h.mat A inlineridxs max_inliners
%  load cvlab02h.mat

figure(2); clf; imshow(cat(2, im1,im2)); hold on;
% plot(Locs1(:,1),Locs1(:,2), 'ro', 'markersize',10);
% plot(Locs2(idxs2,1)+size(im1,2), Locs2(idxs2,2), 'gx','markersize',10);

for i = 1 : numel(inlineridxs)
   plot([Locs1(inlineridxs(i),1), Locs2(idxs2(inlineridxs(i)),1)+size(im1,2)],...
        [Locs1(inlineridxs(i),2), Locs2(idxs2(inlineridxs(i)),2)], 'ro','markersize',10);
end
% 保存图像
cdata = print('-RGBImage');
imwrite(cdata, 'harris2img_ransac.png');

%%
%
nx2 = size(im2,2); ny2 = size(im2,1);
xsbound2 = [1 nx2 nx2 1];
ysbound2 = [1 1 ny2 ny2];
Aff = A;
x2bound=[xsbound2;ysbound2;ones(1,4)]';
x2bound_transformed=homography_transform(Aff, x2bound);    
x2bound_transformed=x2bound_transformed';
x2bound_transformed=x2bound_transformed(1:2,:);
% x2bound_transformed = Aff * [xsbound2;ysbound2;ones(1,4)];

% 绘制出来边框
figure(1); hold on;
plot([x2bound_transformed(1,:) x2bound_transformed(1,1)],...
     [x2bound_transformed(2,:) x2bound_transformed(2,1)],'r-');

% 计算合成两幅照片
nx1 = size(im1,2); ny1 = size(im1,1);
xlo = min([1 x2bound_transformed(1,:)]); xlo = max(ceil(xlo),1);
xhi = max([nx1 x2bound_transformed(1,:)]); xhi = ceil(xhi);
ylo = min([1 x2bound_transformed(2,:)]); ylo = max(ceil(ylo),1);
yhi = max([ny1 x2bound_transformed(2,:)]); yhi = ceil(yhi);

%%
% 记录两个边框
bounds = cell(2,4);
bounds{1,1} = [1 nx1 nx1 1;1 1 ny1 ny1] - repmat([-xlo+1;-ylo+1],[1 4]);
bounds{2,1} = x2bound_transformed - repmat([-xlo+1;-ylo+1],[1 4]);

bounds{1,2} = [1 0 -xlo+1; 0 1 -ylo+1];
bounds{2,2} = Aff; 

% 生成Mask信息
sigma = 0.75;
[xg1,yg1] = meshgrid(1:nx1, 1:ny1); 
mask1 = (xg1 - nx1/2.0).^2 ./(sigma*nx1)^2 + (yg1 - ny1/2.0).^2./(sigma*ny1)^2;
[xg2,yg2] = meshgrid(1:nx2, 1:ny2);
mask2 = (xg2 - nx2/2.0).^2 ./(sigma*nx2)^2 + (yg2 - ny2/2.0).^2./(sigma*ny2)^2;

bounds{1,3} = exp(-mask1);
bounds{2,3} = exp(-mask2);

bounds{1,4} = im1;
bounds{2,4} = im2;

%% 进行图像的合并
nc = size(im1,3);
imTotal = zeros(yhi-ylo+1, xhi-xlo+1, nc);

% 设计一个Mask
maskTotal = zeros(yhi-ylo+1, xhi-xlo+1);

% 开始挪动图像区域
figure(2);clf; imshow(uint8(imTotal));
hold on;

% 第一张图片变换
for i = 1 
   plot([bounds{i,1}(1,:) bounds{i,1}(1,1)],...
        [bounds{i,1}(2,:) bounds{i,1}(2,1)], 'r-');
    
   xlo_i = max(ceil(min(bounds{i,1}(1,:))),1);
   xhi_i = ceil(max(bounds{i,1}(1,:)));
   ylo_i = max(ceil(min(bounds{i,1}(2,:))),1);
   yhi_i = ceil(max(bounds{i,1}(2,:)));
   
   [xg_i,yg_i] = meshgrid(xlo_i:xhi_i,ylo_i:yhi_i);
   
   Aff = bounds{i,2};
   coords_i = inv(Aff(1:2,1:2)) * ([xg_i(:) yg_i(:)]' - repmat(Aff(:,3),[1, numel(xg_i)]));
   xcoords_i = reshape(coords_i(1,:), size(xg_i));
   ycoords_i = reshape(coords_i(2,:), size(xg_i));
   
   im_i = zeros(yhi_i-ylo_i+1, xhi_i-xlo_i+1,nc);
   for j = 1 : nc
    im_i(:,:,j) = interp2(double(bounds{i,4}(:,:,j)), xcoords_i, ycoords_i, 'linear', 0);
   end
   mask_i = interp2(bounds{i,3}, xcoords_i, ycoords_i, 'linear', 0);
   figure(3);imshow(uint8(im_i));
   figure(4);imagesc(mask_i);
   
   imTotal(ylo_i:yhi_i, xlo_i:xhi_i, :) = imTotal(ylo_i:yhi_i, xlo_i:xhi_i, :)  + im_i .* repmat(mask_i, [1 1 nc]);
   maskTotal(ylo_i:yhi_i, xlo_i:xhi_i) = maskTotal(ylo_i:yhi_i, xlo_i:xhi_i) + mask_i;
end


% 第二张图 单应矩阵变换
for i = 2
   plot([bounds{i,1}(1,:) bounds{i,1}(1,1)],...
        [bounds{i,1}(2,:) bounds{i,1}(2,1)], 'r-');
    
   xlo_i = max(ceil(min(bounds{i,1}(1,:))),1);
   xhi_i = ceil(max(bounds{i,1}(1,:)));
   ylo_i = max(ceil(min(bounds{i,1}(2,:))),1);
   yhi_i = ceil(max(bounds{i,1}(2,:)));
   
   [xg_i,yg_i] = meshgrid(xlo_i:xhi_i,ylo_i:yhi_i);
   
   Aff = bounds{i,2};
   
   
   coords_i = homography_transform(inv(Aff),[xg_i(:) yg_i(:) ones(length(xg_i(:)),1)]); 
   xcoords_i=coords_i(:,1);
   ycoords_i=coords_i(:,2);   
   xcoords_i = reshape(xcoords_i, size(xg_i));
   ycoords_i = reshape(ycoords_i, size(xg_i));
   
   im_i = zeros(yhi_i-ylo_i+1, xhi_i-xlo_i+1,nc);
   for j = 1 : nc
    im_i(:,:,j) = interp2(double(bounds{i,4}(:,:,j)), xcoords_i, ycoords_i, 'linear', 0);
   end
   mask_i = interp2(bounds{i,3}, xcoords_i, ycoords_i, 'linear', 0);
   figure(3);imshow(uint8(im_i));
   figure(4);imagesc(mask_i);
   
   imTotal(ylo_i:yhi_i, xlo_i:xhi_i, :) = imTotal(ylo_i:yhi_i, xlo_i:xhi_i, :)  + im_i .* repmat(mask_i, [1 1 nc]);
   maskTotal(ylo_i:yhi_i, xlo_i:xhi_i) = maskTotal(ylo_i:yhi_i, xlo_i:xhi_i) + mask_i;
end
    
imTotal = imTotal./repmat(maskTotal+1e-20,[1 1,3]);
figure(5); imshow(uint8(imTotal));
