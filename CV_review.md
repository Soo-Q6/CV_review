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
## 数字图像处理基础
### 几何变换
#### 变换类型
* 欧几里得变换<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_10-41-52.png)
* 相似变换<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_10-43-11.png)
* 仿射变换<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_10-44-43.png)
#### 前向变换和后向变换
1. 前向变换<br>
* 遍历输入图像I的像素(x,y)
* 根据集合Bain还，生成相应的像素点(x',y')
* 填充输出图像O的相应位置的像素值O(x',y')=I(x,y)
<br>前向变换会产生填充的空洞
2. 后向变换
*确定后向变换的输出图像O的区域
* 便利输出图像O的像素(x',y')
* 根据逆变换，寻找输入图像的相应像素位置(x,y)
* 填充输出图像O的相应位置的像素值O(x',y')=I(x,y)
<br>后向变换中使用插值（双线性插值）
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_10-53-26.png)
### 灰度变换
灰度变换将单个像素的值映射到另外一个值,表示为t=T(s),其中s为图像I(x,y)
* 图像反转<br>
t=T(s)=255-s
* 图像增强<br>
图像增强的原理是按需扩展或者压缩图像的灰度等级，将感兴趣的灰度范围扩展，相对一直不感兴趣的灰度区域。<br>
常用的灰度变换方法：分段线性函数，非线性的灰度变换（对数，指数），幂律变换（将图像像素值归一化，根据幂次方的数值判断压缩还是扩展，其中，当次幂大于一，整体变暗，低灰度压缩，高灰度扩展)
* 直方图
<br>
直方图反应的是图像的明暗程度，细节是否清晰，动态范围的大小等。
> 1. 直方图均衡算法
> 2. 给定灰度图像，计算像素出现的频率
> 3. 计算累计频率c（介于0~1之间）
> 4. 灰度变换函数：t=T(s)=round((max-min)*c+min)

### 空间滤波
了解四邻域和八邻域的概念
<br>
#### 模板运算
模板运算分为全尺寸，同等尺寸以及有效尺寸
1. 遍历图像，模板中心与图中某像素位置重合
2. 将模板上系数与像素值对应
3. 将和赋值给途中模板中心对应像素点
<br>
<br>
卷积运算相当于将卷积运算的滤波器进行x轴y轴反转
<br>
<br>
高斯模板的平滑效果，导数模板
### 频域滤波
#### 离散傅里叶变换
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_14-57-10.png)
fft2（）
#### 离散余弦变换
DCT是JPEG压缩标准的核心部分<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_15-11-38.png)
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_15-11-50.png)
<br>计算？