clc
clear
close all

% 读取图像


% 读取图像
img = imread('123.png');
if size(img, 3) == 3  % 检查是否为彩色图像
    img_gray = rgb2gray(img);
else
    img_gray = img;
end


my_horizontal_sobel = [-1 -2 -1; 0 0 0; 1 2 1];
my_vertical_sobel = [-1 0 1; -2 0 2; -1 0 1];



result_image = img_gray;
result_image2 = img_gray;
% 使用Sobel算子进行边缘检测
sobel_x = imfilter(double(img_gray), [-1 -3 -1; 0 0 0; 1 2 1]);
sobel_y = imfilter(double(img_gray), [-1 0 1; -2 0 2; -1 0 1]);


%sobel_x = imfilter(double(img_gray), fspecial('sobel')');
%sobel_y = imfilter(double(img_gray), fspecial('sobel'));

% 计算梯度幅度
gradient_magnitude = sqrt(sobel_x.^2 + sobel_y.^2);

% 二值化梯度图像
threshold_value = 10;
binary_image = imbinarize(gradient_magnitude, threshold_value);
imshow(binary_image);
% 查找连通域
BW = bwboundaries(binary_image, 'noholes');

%imshow(binary_image)

% 使用bwlabel标记所有连通的白色区域
[L, num] = bwlabel(binary_image, 8); 

% 使用regionprops来获取每个区域的面积和边界
stats = regionprops(L, 'Area', 'BoundingBox');

% 找到面积最大的区域
maxArea = 0;
idx = 0;
for i = 1:num
    if stats(i).Area > maxArea
        maxArea = stats(i).Area;
        idx = i;
    end
end

% 用红色框围绕最大的区域
result_image = insertShape(img_gray, 'Rectangle', stats(idx).BoundingBox, 'Color', 'red', 'LineWidth', 2);

% 显示结果
imshow(result_image);
%title('Largest Area Bounded by Red Line');

roi = imcrop(result_image2, stats(idx).BoundingBox);
% 定义高斯滤波器参数
sigma = 1;  % 标准差，调整此值可以改变滤波器的强度

% 使用imgaussfilt函数平滑roi
smoothed_roi = imgaussfilt(roi, sigma);

% 或使用fspecial和imfilter
% h = fspecial('gaussian', [5 5], sigma);
% smoothed_roi = imfilter(roi, h);
threshold_value_roi = 15;  % 调整这个值以获取最佳的二值化效果
sobel_x = imfilter(double(smoothed_roi), 2*[-1 -2 -1; 0 0 0; 1 2 1]);
sobel_y = imfilter(double(smoothed_roi), [-1 0 1; -2 0 2; -1 0 1]);

%sobel_x = imfilter(double(img_gray), fspecial('sobel')');
%sobel_y = imfilter(double(img_gray), fspecial('sobel'));

% 1. 定义滤波器核


% 2. 应用滤波器
%gradient_45 = imfilter(double(smoothed_roi), diagonal_45);
gradient_magnitude = sqrt(sobel_x.^2 + sobel_y.^2);

% 3. 二值化
threshold_value = 10;  % 您可以调整此阈值以获得最佳结果
%binary_image_roi = imbinarize(abs(gradient_45), threshold_value);
binary_image_roi = imbinarize(gradient_magnitude, threshold_value_roi);

% 显示ROI的二值化图像
figure;
imshow(binary_image_roi);
%title('Binarized ROI');
% 使用闭操作修复小空隙
se = strel('disk', 4);
roi_closed = imclose(binary_image_roi, se);
CC_roi = bwconncomp(roi_closed);

% 获取各连通域的像素数量
numPixels = cellfun(@numel, CC_roi.PixelIdxList);

% 找到像素数量最多的连通域
[~, idxLargest] = max(numPixels);

% 创建一个新的二值图像，其中只有最大连通域是白色的
roi_largest = false(size(binary_image_roi));
roi_largest(CC_roi.PixelIdxList{idxLargest}) = true;

% 获取最大连通域的边界
B = bwboundaries(roi_largest);
largest_contour_roi = B{1};

% 将ROI边界映射回原始图像
largest_contour_roi(:,1) = largest_contour_roi(:,1) + stats(idx).BoundingBox(2);
largest_contour_roi(:,2) = largest_contour_roi(:,2) + stats(idx).BoundingBox(1);

y_vals = largest_contour_roi(:,1) + stats(idx).BoundingBox(2)-92.5;
x_vals = largest_contour_roi(:,2) + stats(idx).BoundingBox(1)-222.5;

% 在原始图像上绘制边界
result_image = insertShape(img_gray, 'Line', reshape([x_vals, y_vals]', 1, []), 'Color', 'red', 'LineWidth', 2);
figure;
% 显示结果
imshow(result_image);
title('Largest Edge in ROI');