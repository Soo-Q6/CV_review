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

## 角点检测与特征描述-2
### 拉普拉斯算子与尺度稳定的特征点
随着尺度的变化，如何保证特征点的稳定？？？<br>
* 拉普拉斯算子<br>
对x，y方向进行二次求导相加<br>
简单的拉普拉斯算子容易受噪声影响。可以增加高斯平滑。<br>
也就是LoG算子，其中高斯的方差控制这尺度<br>
利用不同尺度的高斯拉普拉斯算子生成的图片，查找局部极值（单幅图片是8邻域，与相邻两幅图片构成26邻域），这里是寻找特征点？？？
* 高斯差分<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180619134722.jpg)<br>

### SIFT特征点的提取
1. 生成SIFT高斯金字塔<br>
使用高斯卷积的特点逐层生成金字塔
2. DoG的生成<br>
利用生成的高斯金字塔，每两层之间相减生成一个DoG，DoG相比于高斯金字塔数量要减一。<br>
3. 利用生成的DoG，每三幅图片使用26邻域寻找局部极值。

### SIFT特征的方向估计
#### 方向直方图
方向直方图规定了八个标准的方向。生成过程如下：<br>
1. 对于图像中的每一个点，根据其梯度方向寻找到相邻的两个标准方向，计算夹角并且对两个方向进行投票<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180619142434.jpg)<br>
2. 根据每一个点的梯度幅值计算幅度的影响
3. 根据距离中心点的距离修改权值G。
>* 高斯函数
>* 双线性函数
4. 计算完成之后会得到一张方向直方图，选取对应方向最大的作为该点的方向<br>
### HOG和SIFT特征的描述子
#### SIFT特征的区域定义
1. 根据特征点的方向选取一个小的图像块
2. 使用梯度直方图并且进行方向的补偿，将图像块划分为小块，以每一个小块的中心点生成一个小的方向直方图，最后组合形成整体的直方图。并进行归一化处理
3. 进行SIFT特征点匹配
> * L2 difference
> * Cosine distance

#### HOG特征
定义一个block。。。然后和SIFT特征区域定义相似


## 几何变换的应用——morphing和carving
### morphing
morphing是物体的平均，包括几何和外观的平均<br>
morphing是由warping和cross dissolving组合而成的<br>
morphing的实现：
1. 获取平均形状<br>
根据一定的比例确定好两个融合的图像的三角块的顶点的位置
2. 非参数化的warping<br>
使用三个参数a,b,c表示由三个顶点（A，B，C）围成的三角形中的每一个点，由于M=aA+bB+cC的仿射变换不变性，所以可以直接求得对应的变换后的点。也就是对两个图像分别进行变换，然后分别生成平均图像。
3. 获取平均图像
按照比例将两个平均图像相加

### carving
carving是依据图像内容的物体缩放<br>
carving的实现是从x方向或者y方向寻找一条能量最少的一条线，然后将这条线从图像中删除以达到图片的缩放功能<br>
具体思路是：<br>
1. 定义一个seam（假设是有方向）sy={(i,y(i))|i=1...M} s.t. |y(i)-y(i-1)|<=k
2. 寻找一个seam cost E(sy)=ADD(e(S(y(i))))
3. 寻求最优解 min(S(sy))


#### 能量矩阵e
定义一个简单的能量矩阵，即简单的对图像进行x方向和y方向的求导然后相加

#### 如何寻找一个最有的seam
1. 直接搜索？？<br>
> 这个，怕是算不完哦
2. Dijkstra算法，寻求一条从第一行到最后一行的最短路径？<br>
> * 定义一个有向图，其中每一个像素点和它所在的下一行的2k+1邻域内的点构成
> * 构建一个内部集合S，将这个内部集合初始化为第一行
> * 构建一个值函数V（u），记录有向图中任意一个节点到内部集合S的最短路径
> * 逐步增长内部集合S，直到这个集合包含最后一行的像素点
> 这个每一次只能找到一个最优解。。。很烦的所以。。。
3. 动态规划
> * 构建有向图
> * 初始化值函数S的第一行，使用能量矩阵的第一行初始化，初始化路径函数P第一行为0；
> * 按照行扩张，将到达下一行的每一个像素点的最优路径找出来，为S赋值，同时记录对应的路径函数P
> * 逐步增长直到最后一行，通过查找最小的S对应的最后一行的像素点以及路径函数恢复最优的seam

## 摄像机参数矩阵
### 内参矩阵K
* 使用齐次坐标表示三维的射线
* 摄像机中心
* 主平面：过摄像机中心且平行与投影平面
* 主方向：垂直于主平面的方向
* 主轴：过摄像机中心且沿着主方向的直线
* 主点：主轴与成像平面的交点
### 外参矩阵[R t]
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-20_02-33-37.png)<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-20_02-34-36.png)<br>
### 畸变模型L
镜头的畸变是距离principle point距离的一个函数<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-20_04-02-53.png)<br>

进行径向畸变的矫正

## 摄像机标定
### 二维空间的点和线
二维空间中两个点的齐次坐标的叉乘得到的是两点的连线<br>
叉乘计算![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-20_04-37-11.png)<br>
同样的，两条直线的交点也可以使用直线的叉乘求取。
### 三维空间的点线面
平面参数：[a,b,c,d],法线方向[a,b,c]<br>
* 三维空间的无穷远点<br>
使用齐次坐标表示。<br>
三维空间中的两条平行线相交于某个无穷远点
###　消失点和消失线
透视投影变换可以将两条平行线相交。<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180620045340.jpg)<br>
* 已知内参矩阵估计旋转矩阵<br>
根据二维空间中的消失点估计矩阵P的相应列，然后再消去内参就能得到旋转矩阵对应列。最后将该列归一化
### 单应矩阵
如何确定一个平面？<br>
使用三个点？？？<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180620050938.jpg)<br>
所以单应矩阵`H=K[RB1+RB2+Rc+t]`
使用八个点（四点对）进行单应矩阵的估计。
### QR分解与投影矩阵的分解
由于QR分解的结果和K[R t]的形式不一样，所以提出了given分解
#### given分解
需要将P32,P31和P21是那个位置的值置为零。
1. 首先先将P32置为零<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180620052806.jpg)<br>
2. 将第一步计算的结果再将P31置为零<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180620053131.jpg)<br>
3. 将第二步计算的结果再将P21置为零<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180620053725.jpg)<br>
given 分解的结果就是一个上三角矩阵和一个正交阵的乘积，但是值得注意的是由于每一步都有两个解，所以我们需要将最后的产生的八个可能的解进行判断，其中判断的依据就是上三角矩阵的对角线元素必须是大于0的。<br>
注释：上三角矩阵的最后形式不一定就是内参矩阵的形式，其中21元素不一定为0 ，其中的原因是ccd不一定是方形的。
### 张正友标定法
针对标定板设定一个公共的坐标，这样未知数就只有3(K)+6n(R and t)个，而方程数有2np个，其中n是图像的数目，p是点的数目。
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-20_05-56-30.png)<br>
二维平面上的点经过单应矩阵映射到图像上。
通过已知的单应矩阵求解K和[r1 r2 t],其中利用r1和r2的性质（正交列举两个方程即可求解）。
### 三角化
标定的两个或者多个摄像机，求解三维空间的点的坐标


## 单图像的测量
### 交比（cross ratio）
为什么交比是透视投影不变的？？？<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180620093442.jpg)<br>
### 双视几何
给定B视场中的一个点，在A视场中存在一条穿过对应点的直线，在两人的视场中存在意义对应的电荷线关系。通过`8个二维点对`可以确定两个拍摄者之间的相对旋转和评议关系。
#### 基础矩阵
1. 求摄像机中心在世界坐标系的坐标：<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180620102540.jpg)<br>
2. 求图像中某点在世界坐标系下坐标：<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180620103517.jpg)<br>
3. 什么是基础矩阵：<br>
三维空间上同一个点在A，B的相机中成像（v，u），通过一个双线性的方程兰溪起来，联系这个点对的矩阵F称之为基础矩阵，它隐式的记录了两个相机之间的相对的（R，t）。
* 极平面：B图像中的一点U和B以及A对应的摄像机中心后成的一个物理平面
* 极点：B摄像机中心在A图像中的成像称为几点
* 极线：由B图像上的点U定义的极平面与A图像的交线称为极线，所有的极线都相交于一点（极点）。A极线上任意一点可能是B对应点的匹配点。
* 计算两个极点，可以估计摄像机的平移和旋转？？？
* 极线的计算<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/微信图片_20180620113144.jpg)<br>
根据计算的lv可以计算lu？这里是基础矩阵的意思？<br>
![](https://github.com/Soo-Q6/CV_review/raw/master/photo/Snipaste_2018-06-20_11-38-54.png)<br>
#### 摄像机运动的估计
估计基础矩阵需要多少个点对？
