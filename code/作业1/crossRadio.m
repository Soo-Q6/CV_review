%clear;clc;
im1=imread('pic1.jpg');
figure(1),imshow(im1);
hold on;


load points.mat
%[Xx,Xy]=ginput(4);
figure(1); hold on;
plot(Xx, Xy,'rs','markersize',15);
Xx=round(Xx);
Xy=round(Xy);
Xline1=cross([Xx(1),Xy(1),1],[Xx(2),Xy(2),1]);  
line([Xx(1),Xx(2)],[Xy(1),Xy(2)],'color','red');
Xline2=cross([Xx(3),Xy(3),1],[Xx(4),Xy(4),1]); 
line([Xx(3),Xx(4)],[Xy(3),Xy(4)],'color','red');  
Xpoint=cross(Xline1,Xline2);   %X方向的消失点
Xpoint=round(Xpoint/Xpoint(3));
    plot(Xpoint(1), Xpoint(2),'ys','markersize',15);
line([Xx(1),Xpoint(1)],[Xy(1),Xpoint(2)],'color','red');
line([Xx(3),Xpoint(1)],[Xy(3),Xpoint(2)],'color','red'); 

%[Yx,Yy]=ginput(4);
    figure(1); hold on;
    plot(Yx, Yy,'rs','markersize',15);
Yx=round(Yx);
Yy=round(Yy);
Yline1=cross([Yx(1),Yy(1),1],[Yx(2),Yy(2),1]);
line([Yx(1),Yx(2)],[Yy(1),Yy(2)],'color','red');
Yline2=cross([Yx(3),Yy(3),1],[Yx(4),Yy(4),1]);
line([Yx(3),Yx(4)],[Yy(3),Yy(4)],'color','red'); 
Ypoint=cross(Yline1,Yline2);     %Y方向的消失点
Ypoint=round(Ypoint/Ypoint(3));
    plot(Ypoint(1), Ypoint(2),'ys','markersize',15);
line([Yx(1),Ypoint(1)],[Yy(1),Ypoint(2)],'color','red');
line([Yx(3),Ypoint(1)],[Yy(3),Ypoint(2)],'color','red'); 
XYline=cross(Xpoint,Ypoint);
line([Xpoint(1),Ypoint(1)],[Xpoint(2),Ypoint(2)],'color','yellow');


%[Zx,Zy]=ginput(4);
    figure(1); hold on;
    plot(Zx, Zy,'rs','markersize',15);
Zline1=cross([Zx(1),Zy(1),1],[Zx(2),Zy(2),1]);
Zline2=cross([Zx(3),Zy(3),1],[Zx(4),Zy(4),1]);
Zpoint=cross(Zline1,Zline2);    %Z方向的消失点
Zpoint=round(Zpoint/Zpoint(3));
    plot(Zpoint(1), Zpoint(2),'ys','markersize',15);
line([Zx(1),Zpoint(1)],[Zy(1),Zpoint(2)],'color','red');
line([Zx(3),Zpoint(1)],[Zy(3),Zpoint(2)],'color','red'); 
  

%labBasePoint=ginput(1);
    plot(labBasePoint(1), labBasePoint(2),'gs','markersize',15);
    


%[manx,many]=ginput(2);
plot(manx, many,'bs','markersize',15);
baseline1=cross([manx(2),many(2),1],[labBasePoint(1),labBasePoint(2),1]); % 人脚y方向 
nYpoint=cross(baseline1,XYline);
nYpoint=round(nYpoint/nYpoint(3));
    plot(nYpoint(1), nYpoint(2),'ys','markersize',15);
line([manx(2),nYpoint(1)],[many(2),nYpoint(2)],'color','blue');
Zcrossline=cross(Zpoint,[labBasePoint(1),labBasePoint(2),1]);
line([Zpoint(1),labBasePoint(1)],[Zpoint(2),labBasePoint(2)],'color','green');

labTopPoint=cross(Zcrossline,Xline1);
labTopPoint=round(labTopPoint/labTopPoint(3));
    plot(labTopPoint(1), labTopPoint(2),'gs','markersize',15);
baseline2=cross(nYpoint,[manx(1),many(1),1]);      %人头Y方向
line([manx(1),nYpoint(1)],[many(1),nYpoint(2)],'color','blue');
crosspoint=cross(baseline2,Zcrossline);
crosspoint=round(crosspoint/crosspoint(3));
    plot(crosspoint(1), crosspoint(2),'ys','markersize',15);

AC=sqrt((labBasePoint(1)-labTopPoint(1))^2+(labBasePoint(2)-labTopPoint(2))^2);
AB=sqrt((crosspoint(1)-labBasePoint(1))^2+(crosspoint(2)-labBasePoint(2))^2);
BC=AC-AB;
BD=sqrt((crosspoint(1)-Zpoint(1))^2+(crosspoint(2)-Zpoint(2))^2);
AD=sqrt((labBasePoint(1)-Zpoint(1))^2+(labBasePoint(2)-Zpoint(2))^2);
h1=1.7;
h2=AC*AD*h1/(AB*BD)