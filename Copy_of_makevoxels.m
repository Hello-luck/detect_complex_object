function voxels = Copy_of_makevoxels(xlim,ylim,zlim,N)
%MAKEVOXELS  create a basic grid of voxels ready for carving
%
%   VOXELS = MAKEVOXELS(N) makes a grid of voxels of size NxNxN in a
%   pre-defined volume.

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $

error( nargchk( 4, 4, nargin ) );


% We need to create cube-shaped voxels, so choose a resolution to give
% roughly N voxels

% diff是xlim的差值，总为正数
volume = diff( xlim ) * diff( ylim ) * diff( zlim );

% 用于计算一个体积被分割成特定数量小块（体素）时，每个体素的边长
voxels.Resolution = power( volume/N, 1/3 );

%以步长为边长增加到最大值
x = xlim(1) : voxels.Resolution : xlim(2);
y = ylim(1) : voxels.Resolution : ylim(2);
z = zlim(1) : voxels.Resolution : zlim(2);

% 代码的目的是创建一个三维网格
% meshgrid 函数为这些坐标点生成了三维坐标网格，
% 其中 X, Y, Z 矩阵包含了网格上每个点的 X, Y, Z 坐标。
[X,Y,Z] = meshgrid( x, y, z );

% 这几行代码将三维网格的坐标数据
% 赋值给 voxels 结构体的 XData, YData, 和 ZData 字段
% 就可以理解为1个立方体
voxels.XData = X(:);
voxels.YData = Y(:);
voxels.ZData = Z(:);
% 每个元素都被初始化为 1。这意味着初始时，
% 每个体素都被认为是"实体"的（或者说在空间雕刻过程中是有效的）。
voxels.Value = ones(numel(X),1);







