
% demo_laplacian_blend 
% 读入两幅照片，以及采用genMask标记的图像区域

imSource = imread('z.jpg');  
maskA = load('cat.mat', 'BW');  maskA = maskA.BW; maskA = double(maskA);
imTarget = imread('house.png'); 

%%
% 通过padding，将两幅照片的大小实现一致了
szSource = size(imSource ); if(size(imSource,3) == 1), szSource(3) = 1; end
szTarget = size(imTarget); if(size(imTarget,3) == 1), szTarget(3) = 1; end
sz = max([szSource(:) szTarget(:)],[],2);

% 对图像A和模板maskA进行Padding
if(szSource(1) < sz(1))
    imSource_pad = vertcat(imSource, zeros(sz(1)-szSource(1), szSource(2), szSource(3)));
    maskA_pad = vertcat(maskA, zeros(sz(1) - szSource(1), szSource(2)));
else
    imSource_pad = imSource;
    maskA_pad = maskA;
end
if(szSource(2) < sz(2))
   imSource_pad =  horzcat(imSource_pad, zeros(size(imSource_pad,1), sz(2) - szSource(2), szSource(3)));
   maskA_pad = horzcat(maskA_pad, zeros(size(imSource_pad,1), sz(2) - szSource(2)));
end
if(szSource(3) < sz(3))
    imSource_pad = repmat(imSource_pad,[1 1 3]);
end

% 对图像B进行Padding
if(szTarget(1) < sz(1))
    imTarget_pad = vertcat(imTarget, zeros(sz(1)-szTarget(1), szTarget(2), szTarget(3)));
else
    imTarget_pad = imTarget;
end
if(szTarget(2) < sz(2))
   imTarget_pad =  horzcat(imTarget_pad, zeros(size(imTarget_pad,1), sz(2) - szTarget(2), szTarget(3)));
end
if(szTarget(3) < sz(3))
    imTarget_pad = repmat(imTarget_pad,[1 1 3]);
end

%%
% 获取一个位置信息
figure(1);imshow(uint8(imTarget_pad));
[xshift,yshift] = ginput(1);

% 获取原始图像中
maskPoints = load('cat.mat', 'xi', 'yi');
xshift = (xshift - mean(maskPoints.xi));
yshift = (yshift - mean(maskPoints.yi));

% 将图像A和它的模板都进行平移
imSource_pad = imtranslate(imSource_pad, [xshift, yshift]);
maskA_pad = imtranslate(maskA_pad, [xshift, yshift]);

%取整
maskA_pad=ceil(maskA_pad);


figure;imshow(uint8(imSource_pad));
figure;imshow(uint8(maskA_pad)*255);

%%
[m,n]=size(maskA_pad);
% 求取Af=b中f的大小
f_length=length(find(maskA_pad~=0));

w=[0,-1,0;-1,4,-1;0,-1,0];
for l=1:sz(3)
    %source&target的拉普拉斯变换
    lapsSource=templet(imSource_pad(:,:,l),w);

    %求取b向量并且对maskA_pad进行编号
    b=zeros(f_length,1);
    k=0;
    for i=1:m
        for j=1:n
            if maskA_pad(i,j)==1
                k=k+1;
                maskA_pad(i,j)=k;
                b(k)=lapsSource(i,j);
            end
        end
    end



    %A矩阵
    A=zeros(f_length,f_length);

    for i=1:f_length
        location=find(maskA_pad==i);
        location_x=mod(location,m);
        location_y=ceil(location/m);
        if location_x==0
            location_x=m;
        end
        A(i,i)=4;
        if maskA_pad(location_x-1,location_y)==0
            b(i)=b(i)+imTarget(location_x-1,location_y,l);
        else
            A(i,maskA_pad(location_x-1,location_y))= -1;
        end
        if maskA_pad(location_x+1,location_y)==0
            b(i)=b(i)+imTarget(location_x+1,location_y,l);
        else
            A(i,maskA_pad(location_x+1,location_y))= -1;
        end
        if maskA_pad(location_x,location_y-1)==0
            b(i)=b(i)+imTarget(location_x,location_y-1,l);
        else
            A(i,maskA_pad(location_x,location_y-1))= -1;
        end
        if maskA_pad(location_x,location_y+1)==0
            b(i)=b(i)+imTarget(location_x,location_y+1,l);
        else
            A(i,maskA_pad(location_x,location_y+1))= -1;
        end
    end


    %求解f    
    f=sparse(A)\b;

    for i=1:f_length
        location=find(maskA_pad==i);
        location_x=mod(location,m);
        location_y=ceil(location/m);
        if location_x==0
            location_x=m;
        end
        imTarget(location_x,location_y,l)=f(i);
    end
end
figure;
imshow(uint8(imTarget));



