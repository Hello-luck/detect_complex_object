% 读取图像
img = imread('123.jpg'); % 替换 'your_image.png' 为您的图像文件名



% 如果是彩色图像，转换为灰度图像
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end
sigma =2;  % 标准差，调整此值可以改变滤波器的强度

smoothed_roi = imgaussfilt(img_gray, sigma);

% Sobel算子
my_horizontal_sobel = [-1 -2 -1; 0 0 0; 1 2 1];
my_vertical_sobel = [-1 0 1; -2 0 2; -1 0 1];

% 使用Sobel算子进行边缘检测
sobel_x = imfilter(double(smoothed_roi), my_horizontal_sobel, 'replicate');
sobel_y = imfilter(double(smoothed_roi), my_vertical_sobel, 'replicate');

% 计算梯度幅度
gradient_magnitude = sqrt(sobel_x.^2 + sobel_y.^2);

% 二值化梯度图像，使用阈值
threshold_value =1; % 根据您图像的具体情况，这个阈值可能需要调整
binary_image = imbinarize(gradient_magnitude, threshold_value);
% 假设binary_image是二值化后的图像


se = strel('disk', 5);

% 应用开运算以去除小噪点并平滑物体的边界
opened_image = imopen(binary_image, se);

% 清除仍然存在的小物体
clean_image = bwareaopen(opened_image, 100); % 100是一个示例阈值，您需要根据情况调整
se = strel('square',270); % 您可以调整结构元素的大小和形状

% 对二值化图像进行闭运算
closed_image = imclose(clean_image, se);
% 提取轮廓

% 使用imgaussfilt函数平滑roi

figure;
imshow(opened_image);
figure;
imshow(clean_image);
title('clean_image', 'FontSize', 14, 'Color', 'r');
figure;
imshow(closed_image);
title('Closed Image', 'FontSize', 14, 'Color', 'r');
% 查找二值化图像中的轮廓
[contours, ~] = bwboundaries(closed_image, 'noholes');

maxContour = [];
maxContourSize = 0;
for i = 1:length(contours)
    % 获取凸包
    convexHull = bwconvhull(poly2mask(contours{i}(:,2), contours{i}(:,1), size(img_gray,1), size(img_gray,2)));
    
    % 计算凸包大小
    convexHullSize = sum(convexHull(:));
    
    if convexHullSize > maxContourSize
        maxContourSize = convexHullSize;
        maxContour = contours{i};
    end
end

% 绘制原图或灰度图
figure;
imshow(img_gray); 
hold on;

% 计算并绘制最大凸包轮廓
convexHullImage = bwconvhull(poly2mask(maxContour(:,2), maxContour(:,1), size(img_gray,1), size(img_gray,2)));
boundaries = bwboundaries(convexHullImage);
for k = 1:length(boundaries)
    b = boundaries{k};
    plot(b(:,2), b(:,1), 'r', 'LineWidth', 2);
end

hold off;
% 继续使用之前的脚本中的变量
% 绘制原图或灰度图
figure;
imshow(img_gray);
hold on;

% 计算并绘制最大凸包轮廓的椭圆近似
convexHullImage = bwconvhull(poly2mask(maxContour(:,2), maxContour(:,1), size(img_gray,1), size(img_gray,2)));

% 使用regionprops获取椭圆属性
stats = regionprops(convexHullImage, 'MajorAxisLength', 'MinorAxisLength', 'Orientation', 'Centroid');

% 只对最大的区域绘制椭圆
if ~isempty(stats)
    % 获取椭圆参数
    maxArea = max([stats.MajorAxisLength]);
    ellipseIdx = find([stats.MajorAxisLength] == maxArea, 1, 'first');
    phi = deg2rad(-stats(ellipseIdx).Orientation);
    axesLength = [stats(ellipseIdx).MajorAxisLength stats(ellipseIdx).MinorAxisLength] / 2;
    center = stats(ellipseIdx).Centroid;
    
    % 计算椭圆上的点
    theta = linspace(0, 2*pi, 360);
    rot = [cos(phi) sin(phi); -sin(phi) cos(phi)];
    xy = [axesLength(1)*cos(theta); axesLength(2)*sin(theta)];
    xy = rot * xy;
    
    % 绘制椭圆
    plot(xy(1,:) + center(1), xy(2,:) + center(2), 'r', 'LineWidth', 2);
end

hold off;
% 假设 max_contour 包含了月牙形轮廓的坐标


