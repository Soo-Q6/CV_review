# CV_review
this is my review of the computer version in XJTU


## 摄像机
小孔成像模型
### 三维点的投影
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_09-50-19.png)

将三维世界的点投影到二维平面上，此处是度量空间。</br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_10-04-09.png)
<br>将三维空间的点投影到二维平面上，此处是像素空间

### 齐次坐标
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_10-12-41.png)
<br>二维图像中的点的齐次坐标表示三位空间上的一点，三维世界的点与摄像机连线的射线与投影平面的交点就是投影点。<br>
### 三维透视投影变换
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_10-17-49.png)
<br>
## 图像的表示
### 图像的三个基本属性
* 分辨率：像素密度的度量方法
* 像素深度（位深）：存储每个像素的位数
* 彩色
### 计算屏幕尺寸
`
size=sqrt(pixel_width^2+pixel_heigth^2)*dot_pitch/25.4
`
### 图像的表示
1. 矢量图<br>
采用数学表达式描述一幅图
2. 点位图<br>
