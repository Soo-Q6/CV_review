
function laps1 = genPyramids(im1, nlvls)

if(nargin <= 1)
    nlvls = 4;
end
w = [1/8 1/4 1/4 1/4 1/8];

laps1 = cell(nlvls,2); 
laps1{1,1} = double(im1);
for i = 2 : nlvls
    laps1{i,1} = reduce(laps1{i-1,1},w);
end
laps1{end,2} = laps1{end,1};
for i = nlvls-1 : -1 : 1
    temp = expand(laps1{i+1,1},w);
    expSize = size(temp);
    orgSize = size(laps1{i,1});
    if(expSize(1) < orgSize(1))
        temp = vertcat(temp, temp(end,:,:));
    end
    if(expSize(2) < orgSize(2))
       temp =  horzcat(temp, temp(:,end,:));
    end
    laps1{i,2} = laps1{i,1} - temp;
end
end



function output = reduce(input,w)
[m,n,l]=size(input);
padding=floor(length(w)/2);
input=padarray(input,[0,padding],0);
first_reduce=zeros(m,floor(n/2),l);
for k=1:l
    for i=1:m
        for j=padding+2:2:n+padding
            first_reduce(i,(j-padding)/2,k)=w*input(i,j-padding:j+padding,k)';
        end
    end
end
output=zeros(floor(m/2),floor(n/2),l);
first_reduce=padarray(first_reduce,[padding,0],0);
for k=1:l
    for i=padding+2:2:m+padding
        for j=1:floor(n/2)
            output((i-padding)/2,j,k)=w*first_reduce(i-padding:i+padding,j,k);
        end
    end
end
end

function output=expand(input,w)
[m,n,l]=size(input);
padding=ceil((length(w)-1)/4);
input=padarray(input,[padding,0],0);
first_expand=zeros(2*m,n,l);
for x=1:l
    for i=1:2*m
        for j=1:n
            if mod(i,2)==0
                for k=0:2:(length(w)-1)/2
                    if k==0
                        first_expand(i,j,x)=first_expand(i,j,x)+input((i-k)/2+padding,j,x)*w((length(w)+1)/2+k);
                    else
                        first_expand(i,j,x)=first_expand(i,j,x)+input((i+k)/2+padding,j,x)*w((length(w)+1)/2+k);
                        first_expand(i,j,x)=first_expand(i,j,x)+input((i-k)/2+padding,j,x)*w((length(w)+1)/2-k);
                    end
                end
            else
                for k=1:2:(length(w)-1)/2
                    first_expand(i,j,x)=first_expand(i,j,x)+input((i+k)/2+padding,j,x)*w((length(w)+1)/2+k);
                    first_expand(i,j,x)=first_expand(i,j,x)+input((i-k)/2+padding,j,x)*w((length(w)+1)/2-k); 
                end
            end
            first_expand(i,j,x)=first_expand(i,j,x)*2;
        end
    end
end
first_expand=padarray(first_expand,[0,padding],0);
output=zeros(2*m,2*n,l);
for x=1:l
    for i=1:2*m
        for j=1:2*n
            if mod(j,2)==0
                for k=0:2:(length(w)-1)/2
                    if k==0
                        output(i,j,x)=output(i,j,x)+first_expand(i,(j-k)/2+padding,x)*w((length(w)+1)/2+k);
                    else
                        output(i,j,x)=output(i,j,x)+first_expand(i,(j+k)/2+padding,x)*w((length(w)+1)/2+k);
                        output(i,j,x)=output(i,j,x)+first_expand(i,(j-k)/2+padding,x)*w((length(w)+1)/2-k);
                    end
                end
            else
                for k=1:2:(length(w)-1)/2
                    output(i,j,x)=output(i,j,x)+first_expand(i,(j+k)/2+padding,x)*w((length(w)+1)/2+k);
                    output(i,j,x)=output(i,j,x)+first_expand(i,(j-k)/2+padding,x)*w((length(w)+1)/2-k); 
                end
            end
            output(i,j,x)=output(i,j,x)*2;
        end
    end
end
end