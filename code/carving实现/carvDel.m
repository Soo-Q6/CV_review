function carvDel(im)


% ����roipoly��ͼƬ1��ѡ�����Ȥ����
figure(1);clf; %imshow(im1);
[BW, xi, yi] = roipoly(im);
mask=BW;
mask=xor(mask,1);
mask=double(mask);
im=double(im);
dx=round(max(xi)-min(xi));
dy=round(max(yi)-min(yi));
%im1=im.*mask;
if dx<dy
    [im, T, rmIdxs, rmIdxs0] = carv(im,0,dx,mask);
    carvAdd(im,0,dx);
else
    [im, T, rmIdxs, rmIdxs0] = carv(im,dy,0,mask);
    carvAdd(im,dy,0);   
end
end