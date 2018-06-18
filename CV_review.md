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
### 卷积运算
卷积运算相当于将卷积运算的滤波器进行x轴y轴反转
<br>高斯模板的平滑效果，导数模板<br>
### 频域滤波
#### 离散傅里叶变换
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_14-57-10.png)
fft2（）
#### 离散余弦变换
DCT是JPEG压缩标准的核心部分<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_15-11-38.png)
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_15-11-50.png)
<br>计算？


## canny edge detection
### canny边缘检测算法
1. 利用高斯梯度算子对图像进行滤波<br>
对图像进行x，y方向的求偏导，然后进行高斯平滑，由于卷积的结合律，所以可以先对高斯算子进行求偏导，索格结果再与图像进行卷积。
```matlab
[dx,dy]=gradient(G); % D is a 2D gaussain;
Ix=ocnv2(I,dx,'same');
Iy=conv2(I,dy,'same');
```
2. 根据滤波结果计算每一个像素点的边缘强度<br>
对Ix和Iy求平方和
```matlab
Im=sqrt(Ix.*Ix+Iy.*Iy);
```
3. 计算边缘方向<br>
根据Ix和Iy计算梯度方向，使用quiver显示方向。。。
4. 检测局部最大值<br>
沿着梯度方向搜索最大值：
首先进行阈值处理，然后沿着梯度方向搜索（梯度方向需要被限制，八邻域方向）
5. 连接生成边缘<br>
沿着边缘放方向搜索下一个边缘点<br>
迟滞边缘生成，使用threshold_low和threshold_high判断是不是，将点分成100%是边缘，50%是边缘，0%是边缘，当找到边缘点时，根据边缘方向寻找下一个点，如果该点的值在threshold_low之上，则将其标为边缘点，否则不是边缘点。

## 高斯拉普拉斯金字塔
金字塔是进行图像的多尺度分析的基础
### 高斯金字塔
高斯金字塔的生成是利用高斯平滑和降采样实现的，使用可分离的高斯算子进行高斯平滑
### reduce和expand
1. reduce是滤波+降采样构成的<br>
滤波和降采样可以同时进行，同时根据高斯算子的可分离性，我们可以忽略某些`不必要`的行列。
2. expand是滤波+增采样构成的<br>
expand的操作过程是先将图像进行行或者列的扩展（可分离性质），然后在对每一个像素进行重新采样（增采样），主要是判断需要使用到哪几个上一层的像素值。

### 拉普拉斯金字塔的构建
拉普拉斯金字塔的构建是基于reduce和expand两个操作。其过程如下，先对图像进行reduce操作，对reduce的结果进行expand，然后用原图像减去expand操作的结果，由此获得一个与原图像大小一致的拉普拉斯金字塔，根据层数的要求可以获取多层的拉普拉斯金字塔。但值得注意的是，拉普拉斯金字塔最后一层是存放的最后一次reduce的结果。
### 使用拉普拉斯金字塔恢复图像
对拉普拉斯金字塔最后一层进行expand操作，然后与上一层的拉普拉斯图像相加得到一副`新图像`，重复上述过程就能恢复最初的图像。
### 基于拉普拉斯金字塔的图像合成
1. 建立图像A和B的拉普拉斯金字塔LA和LB
2. 从选择的需要合成的区域中构建一个高斯金字塔MASK
3. 生成一个通过MASK合成LA和LB的拉普拉斯金字塔LS<br>
LS(i,j)=MASK(i,j)*LA(i,j)+(1-MAKS(i,j))*LB(i,j)
4. 使用LS拉普拉斯金字塔合成新图片。

## 梯度融合
融合主要的方式：
1. copy-paste
2. alpha blending<br>
掩膜按照一定的权重进行插值
3. gradient blending<br>
使用梯度值进行拷贝重构

### 梯度融合
使用梯度模值和梯度方向进行图像的重构<br>
[算法](https://github.com/Soo-Q6/CV_review/raw/master/code/梯度合成算法/demo_gradient_blend.m)(怎么计算啊？？？)
1. 标记目标图像的需要求解的像素坐标
2. 计算原图像的拉普拉斯图像，获取原图像的梯度值
3. 构建拉普拉斯算子对应的矩阵A（Ax=b）
4. 求解方程组，并将像素拷贝回目标图像中



## 角点检测与特征描述-1
最小二乘法和SVD分解了解一下
### 几何变换的参数估计
估计仿射变换需要至少三个点。。。
求解方程组Ax=b，直接使用x=A\b或者x=pinv(A)*b
#### 暂时补充一下矩阵的求导方法
### 最小二乘法和svd分解求解
优化minL=||Ax-b||^2<br>
所以L=![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_22-33-24.png)<br>
最后的化简得：<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_22-34-46.png)<br>
关于SVD分解，可以知道![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_22-38-30.png)<br>
其中U和V都是正交矩阵，S是对角矩阵<br>
1. 当A是满秩方阵时<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180618224700.jpg)<br>
2. 当A非满秩方阵<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180618225703.jpg)<br>
### Harris角点检测
使用当前矩形框和周边矩形框的差异来度量当前点的独特性<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180618230917.jpg)<br>
通过计算矩阵H的特征值来判断是否时角点。R=r1*r2-k(r1+r2)^2 其中r1和r2时H矩阵的特征值

### 差异比较之模板匹配
1. SAD(sum of absolute difference)<br>
两个矩阵的对应元素的差的绝对值之和
2. MSE(mean squared error)<br>
两个矩阵的对应元素的平方之和<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_23-17-55.png)<br>
3. NCC(normalized cross correlation)<br>
不知道该怎么描述。。。<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-18_23-20-14.png)<br>
其中的std时两个矩阵的标准差