
% demo_laplacian_blend 

imSource = imread('z.jpg');  
maskA = load('cat.mat', 'BW');  maskA = maskA.BW; maskA = double(maskA);
imTarget = imread('house.png'); 

%%
szSource = size(imSource ); if(size(imSource,3) == 1), szSource(3) = 1; end
szTarget = size(imTarget); if(size(imTarget,3) == 1), szTarget(3) = 1; end
sz = max([szSource(:) szTarget(:)],[],2);

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
figure(1);imshow(uint8(imTarget_pad));
[xshift,yshift] = ginput(1);

maskPoints = load('cat.mat', 'xi', 'yi');
xshift = (xshift - mean(maskPoints.xi));
yshift = (yshift - mean(maskPoints.yi));

imSource_pad = imtranslate(imSource_pad, [xshift, yshift]);
maskA_pad = imtranslate(maskA_pad, [xshift, yshift]);


maskA_pad=ceil(maskA_pad);


figure;imshow(uint8(imSource_pad));
figure;imshow(uint8(maskA_pad)*255);

%%
[m,n]=size(maskA_pad);

f_length=length(find(maskA_pad~=0));

w=[0,-1,0;-1,4,-1;0,-1,0];
for l=1:sz(3)
    lapsSource=templet(imSource_pad(:,:,l),w);

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



