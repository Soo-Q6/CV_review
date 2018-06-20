function g=gaussian_filter(sigma)
g=fspecial('gaussian',[1 7],sigma);
end