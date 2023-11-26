function Copy_of_showcamera(ax,camera,angle)
%SHOWCAMERA: draw a schematic of a camera
%
%   SHOWCAMERA(CAMERA) draws a camera on the current axes
%
%   SHOWCAMERA(AXES,CAMERA) draws a camera on the specified axes
%
%   Example:
%   >> cameras = loadcameradata(1:3);
%   >> showcamera(cameras)
%
%   See also: LOADCAMERADATA

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $

%这个不影响什么，先不去理解了
% if nargin<3
%     camera = ax;
%     ax = gca();
% end

% 这里的 0.2 意味着原始图像将被缩放到原来的 20%。
scale = 40;
% 在图像处理中，子采样意味着在处理或分析图像时只使用图像中的一部分数据点。
subsample = 16;

for c=1:numel(camera)

    % cam_T是平移矩阵,
    % t是相机在世界坐标系中的位置
    cam_t = camera(c).t;
    
    % Draw the camera centre
    %其实就是画出来相机的世界坐标系
    %而t就是相机在世界坐标系中的位置
    plot3(camera(c).t(1),camera(c).t(2),camera(c).t(3),'b.','markersize',10);
    
    % Now work out where the image corners are
    % 获取某个相机拍摄的图像的尺寸和颜色深度
    % 对于一个彩色图像，colordepth 通常是 3
    % 如果 colordepth 是 1，这通常意味着图像是灰度图
    [h,w,colordepth] = size(camera(c).image); %#ok<NASGU>

    %imcorners 是一个 3x4 的矩阵，代表了图像四个角的坐标。
    %矩阵的每一列代表一个角点，顺序通常是左上、右上、左下、右下。
    % (0,0)表示边界而非像素索引：
    % 四个1为齐次，丢失了深度信息
    imcorners = [1 w 1 w
        1 1 h h
        1 1 1 1];

    % 把像素坐标点转化为世界坐标系的点
    worldcorners = iBackProject( imcorners, scale, camera(c),angle );

    % worldcorners(:,1) 用于提取 worldcorners 矩阵的第一列
    % 即将相机在世界坐标系中的位置与图片的角点在世界坐标系中的位置画下来
    iPlotLine(cam_t, worldcorners(:,1), 'b-')
    hold on
    iPlotLine(cam_t, worldcorners(:,2), 'b-')
    iPlotLine(cam_t, worldcorners(:,3), 'b-')
    iPlotLine(cam_t, worldcorners(:,4), 'b-')
    % 
   
    
    % Now draw the image plane. We will need the coords of every pixel in order
    % to do the texturemap

    % 由于 z 轴只有一个值 1，所以这实际上是在 x-y 平面上生成一个二维网格。
    [x,y,z] = meshgrid( 1:subsample:w, 1:subsample:h, 1 );
    % pix 是一个 3 行 N 列的矩阵，其中 N 是网格中点的总数。
    pix = [x(:),y(:),z(:)]';

    % 将像素坐标值转化为世界坐标系的值
    worldpix = iBackProject( pix, scale, camera(c) ,angle);

    % 它每隔 subsample 个像素选取一个像素，既适用于行也适用于列，
    % 实现了图像的下采样。
    % : 表示选择所有颜色通道（对于彩色图像来说通常是 RGB 三个通道）。
    smallim = camera(c).image(1:subsample:end,1:subsample:end,:);

    % surface(...)：这是 MATLAB 中用于创建三维表面图的函数。
    % worldpix(1,:) 取出所有 X 坐标，
    % 然后 reshape 函数将这些坐标重新排列成
    % 一个 h/subsample 行和 w/subsample 列的矩阵。
    % 'texturemap'纹理映射意味着表面的颜色将基于一个图像来设置
    % smallim 图像的内容将被映射到定义的三维表面上。
    %  'none' 意味着不显示表面的边缘
    surface('XData', reshape(worldpix(1,:),h/subsample,w/subsample), ...
        'YData', reshape(worldpix(2,:),h/subsample,w/subsample), ...
        'ZData', reshape(worldpix(3,:),h/subsample,w/subsample), ...
        'FaceColor','texturemap', ...
        'EdgeColor','none',...
        'CData', smallim );
end
set( ax,'DataAspectRatio', [1 1 1] )

%-------------------------------------------------------------------------%
%x是imgcorner， dist是深度， camera是相机参数

%dist原来是distance的缩写
function X = iBackProject( x, dist, camera,angles )
%IBACKPROJECT - backproject an image location a distance DIST and return
%   the equivalent world location.

%size(A, 1)，这意味着您想要获取数组 A 在特定维度上的尺寸。
% %在这个例子中，1 表示您感兴趣的是数组的第一个维度，也就是行的数量。
% 要补全矩阵来进行计算
if size(x,1)==2
    %如果只有2行，新增一个第三行，并且第三行全为1
    x = [x;ones(1,size(x,2))];
end

%x是输入的像素坐标值
%下面这一行等效于 X = inv(cameras(1).K)*x
%这一步的X是相机坐标系的值
X = camera.K \ x;

% 点乘先计算 X 中每个元素的平方
% sum(X.*X, 1) 计算 X 的每一列元素的平方和
% sqrt它用于计算每列平方和的平方根
normX = sqrt(sum(X.*X,1));
% angle = angle_value * pi / 180; % 将角度转换为弧度

R_deltax = [1, 0, 0; 0, cos(angles{1} * pi / 180), -sin(angles{1} * pi / 180); 0, sin(angles{1} * pi / 180), cos(angles{1} * pi / 180)];

R_deltay = [cos(angles{2} * pi / 180), 0, sin(angles{2} * pi / 180); 0, 1, 0; -sin(angles{2} * pi / 180), 0, cos(angles{2} * pi / 180)];

R_deltaz = [cos(angles{3} * pi / 180), -sin(angles{3} * pi / 180), 0; sin(angles{3} * pi / 180), cos(angles{3} * pi / 180), 0; 0, 0, 1];




% 应用小幅度旋转
R_modified = camera.R * R_deltax*R_deltay*R_deltaz;

% repmat 函数用于重复 normX 向量，使其成为与 X 相同行数的矩阵
% 将 X 的每一列向量除以其对应的范数。
X = X ./ repmat(normX,size(X,1),1);

% size(x,2)：这部分代码获取矩阵 x 的列数
% 如果 cameras(1).t 是一个列向量，
% 这意味着它将被复制 size(x,2) 次，形成一个矩阵
% 它有助于去除数据中的尺度差异，强调数据的方向性特征
X = repmat(camera.t,1,size(x,2)) + dist *R_modified'*X;

%-------------------------------------------------------------------------%
function iPlotLine(x0, x1, style)
%x0为相机的平移矩阵,x1为等效的世界坐标，即被缩放的

plot3([x0(1),x1(1)], [x0(2),x1(2)], [x0(3),x1(3)], style);


