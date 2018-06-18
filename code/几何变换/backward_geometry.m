
function outputIm = backward_geometry(inputIm, A)

a=[A(:,1),A(:,2)];    
b=A(:,3);
inputSize = size(inputIm);
if(size(inputIm, 3) == 1)
   inputSize(3) = 1; 
end


[outputSize, deltaShift] = calcOutputSize(inputSize, A, 'loose');
outputIm=uint8(zeros(outputSize(1),outputSize(2),inputSize(3)));
for i = 1 : outputSize(1)
    for j = 1 : outputSize(2)
        if deltaShift(1)>0 || isequal(inputSize,outputSize)
            y = i-deltaShift(1);
        else
            y=i;
        end
        if deltaShift(2)>0 || isequal(inputSize,outputSize)
            x = j-deltaShift(2);
        else
            x=j;
        end
        origin=a\([x;y]-b);  
        ox=origin(1);
        oy=origin(2);
        fox=floor(ox);
        foy=floor(oy);
        cox=ceil(ox);
        coy=ceil(oy);
        dx=ox-fox;
        dy=oy-foy;
        for k = 1 :inputSize(3)
            if ox>=1 && ox <=inputSize(2) && oy>=1 && oy<=inputSize(1)
                outputIm(i,j,k)=(1-dx)*(1-dy)*inputIm(foy,fox,k)+dx*(1-dy)*inputIm(foy,cox,k)+(1-dx)*dy*inputIm(coy,fox,k)+dx*dy*inputIm(coy,cox,k);
            end
        end
    end
end

end


function [outputSize, deltaShift] = calcOutputSize(inputSize, A, type)
% 'crop'
% Make output image B the same size as the input image A, cropping the rotated image to fit
% {'loose'}
% Make output image B large enough to contain the entire rotated image. B is larger than A


ny = inputSize(1);     %height
nx = inputSize(2);     %width
if strcmp(type,'loose')                 % {'loose'}
    inputBoundingBox = [ 1  1 1;...
                        nx  1 1;...
                        nx ny 1;...
                         1 ny 1];
    inputBoundingBox = inputBoundingBox';
    %inputBoundingBox
    outputBoundingBox = A * inputBoundingBox;
    %outputBoundingBox
    xlo = floor(min(outputBoundingBox(1,:)));
    xhi =  ceil(max(outputBoundingBox(1,:)));
    ylo = floor(min(outputBoundingBox(2,:)));
    yhi =  ceil(max(outputBoundingBox(2,:)));


    outputSize=[yhi-ylo+1+abs(A(2,3));xhi-xlo+1+abs(A(1,3));inputSize(3)];
    deltaShift=[1-ylo;1-xlo];
elseif strcmp(type,'crop')                  % 'crop'
    outputSize=inputSize;
    mx=round(nx/2);
    my=round(ny/2);
    M=A*[mx;my;1];
    deltaShift=[my-M(2);mx-M(1)];
else
    error('type error!');
end
end