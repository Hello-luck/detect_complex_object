clc
clear
close all

%调用名为+spacecarving的包，里边有相关函数
import spacecarving.*;

% 输出为DinosaurData的文件夹目录
% 'D:\matlab_ma\sapce carving new\SpaceCarving\SpaceCarving\DinosaurData'
datadir = fullfile( fileparts( mfilename( 'fullpath' ) ), 'DinosaurData' );
close all;

cameras = loadcameradata( datadir );

montage( cat( 4, cameras.Image ) );
set( gcf(), 'Position', [100 100 600 600] )
axis off;


% 找出二值图像的轮廓
for c=1:numel(cameras)
    cameras(c).Silhouette = getsilhouette( cameras(c).Image );
end


%选择最后一幅图片来进行展示
figure('Position',[100 100 600 300]);

subplot(1,2,1)
imshow( cameras(c).Image );
title( 'Original Image' )
axis off

subplot(1,2,2)
imshow( cameras(c).Silhouette );
title( 'Silhouette' )
axis off

%z使画面显示的效率更高
makeFullAxes( gcf );


%确定要雕刻的模型的边界框（x、y 和 z 限制）。 这允许构建初始体素体积。
[xlim,ylim,zlim] = findmodel( cameras );


% 这将创建一个规则的三维网格，以便雕刻。
% OctTrees 和其他细化表示法在内存和计算时间上都能提供更好的效率
% makevoxels创建基本的体素网格，准备雕刻
voxels = makevoxels( [-2,2],  [-2 2],  [-2 2], 6000000);
starting_volume = numel( voxels.XData );

% Show the whole scene
figure('Position',[100 100 600 400]);
showscene( cameras, voxels );

%轮廓被投影到体素阵列上。 轮廓外部的任何体素都会被雕刻掉，
% 只留下模型内部的点。 仅使用一台相机，我们最终得到了恐龙棱镜
% 一台相机无法提供深度信息。

[voxels, keep] = carve( voxels, cameras(2) );
% Show Result
figure('Position',[100 100 600 300]);
subplot(1,2,1)
showscene( cameras(2), voxels );
title( '1 camera' )


% 为每个体素分配实数值而非二进制值：这意味着每个体素不仅简单表示为"存在"或“不存在”
% 而是有一个分数或得分，表示其被“雕刻”掉的比例。
% 移动体素以评估它们的得分：作者提到将所有体素沿每个方向移动三分之一的单位长度，
% 然后检查它们是否会被"雕刻"掉（即从模型中移除）。
% 计算得分：每个体素的得分是基于它被雕刻与未被雕刻的比例
% 这大致相当于估计该体素有多大部分位于物体内部。





