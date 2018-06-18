
% demo_laplacian_blend 

imA = imread('z.jpg');  
maskA = load('cat.mat', 'BW');  maskA = maskA.BW; maskA = double(maskA);
imB = imread('house.png');  


%%

szA = size(imA); if(size(imA,3) == 1), szA(3) = 1; end
szB = size(imB); if(size(imB,3) == 1), szB(3) = 1; end
sz = max([szA(:) szB(:)],[],2);


if(szA(1) < sz(1))
    imA_pad = vertcat(imA, zeros(sz(1)-szA(1), szA(2), szA(3)));
    maskA_pad = vertcat(maskA, zeros(sz(1) - szA(1), szA(2)));
else
    imA_pad = imA;
    maskA_pad = maskA;
end
if(szA(2) < sz(2))
   imA_pad =  horzcat(imA_pad, zeros(size(imA_pad,1), sz(2) - szA(2), szA(3)));
   maskA_pad = horzcat(maskA_pad, zeros(size(imA_pad,1), sz(2) - szA(2)));
end
if(szA(3) < sz(3))
    imA_pad = repmat(imA_pad,[1 1 3]);
end


if(szB(1) < sz(1))
    imB_pad = vertcat(imB, zeros(sz(1)-szB(1), szB(2), szB(3)));
else
    imB_pad = imB;
end
if(szB(2) < sz(2))
   imB_pad =  horzcat(imB_pad, zeros(size(imB_pad,1), sz(2) - szB(2), szB(3)));
end
if(szB(3) < sz(3))
    imB_pad = repmat(imB_pad,[1 1 3]);
end

%%

figure(1);imshow(uint8(imB_pad));
[xshift,yshift] = ginput(1);


maskPoints = load('cat.mat', 'xi', 'yi');
xshift = (xshift - mean(maskPoints.xi));
yshift = (yshift - mean(maskPoints.yi));


imA_pad = imtranslate(imA_pad, [xshift, yshift]);
maskA_pad = imtranslate(maskA_pad, [xshift, yshift]);

maskA_pad=ceil(maskA_pad);

figure;imshow(uint8(imA_pad));
figure;imshow(uint8(maskA_pad)*255);

%%

nlvls = 4;
lapsA = genPyramids(imA_pad, nlvls);
lapsB = genPyramids(imB_pad, nlvls);


lapsMask = genPyramids(maskA_pad, nlvls);

%%

lapsBlend = lapsB;
for i = nlvls-1 : -1 : 1
    lapsBlend{i,2} = lapsA{i,2} .* repmat(lapsMask{i,1}, [1 1 sz(3)]) + ...
                     lapsB{i,2} .* (1 - repmat(lapsMask{i,1}, [1 1 sz(3)]));
end


imBlend = recoverLaplacian(lapsBlend(:,2));
figure;imshow(uint8(imBlend));