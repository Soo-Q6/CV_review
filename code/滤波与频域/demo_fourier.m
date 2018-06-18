
% demo_fourier transform
% construct a 11x11 averaging template
f2 = [zeros(5,11); 1/11*ones(1,11); zeros(5,11)];

%  do the 2d Fourier transform
F2 = dct2(f2);
% construct a 11x11 impluse template
f1 =zeros(11,11);
f1(6,6) = 2;
%  do the 2d Fourier transform
F1 = dct2(f1);
figure;
imshow(abs((F1)),[]);
figure;
imshow(abs((F2)),[]);
figure;
imshow(abs((F1-F2)),[]);
