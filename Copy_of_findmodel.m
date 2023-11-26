function [xlim,ylim,zlim] = Copy_of_findmodel( cameras )
%FINDMODEL: locate the model to be carved relative to the cameras
%
%   [XLIM,YLIM,ZLIM] = FINDMODEL(CAMERAS) determines the bounding box (x, y
%   and z limits) of the model which is to be carved. This allows the
%   initial voxel volume to be constructed.

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $

% 沿着第二维（即水平方向或列方向）连接这些平移向量，
% 在这个例子中为添加列
% 从而形成一个包含所有相机位置的矩阵 camera_positions。
camera_positions = cat( 2, cameras.t );
% 这行代码计算 camera_positions 矩阵中所有 x 坐标（第一行）的最小值和最大值。
xlim = [min( camera_positions(1,:)-200 ), max( camera_positions(1,:)+200)];
ylim = [min( camera_positions(2,:) -200), max( camera_positions(2,:)+200 )];
zlim = [min( camera_positions(3,:) ), max( camera_positions(3,:) )];
disp(xlim);
% For the zlim we need to see where each camera is looking. 
%range = 1 * sqrt( diff( xlim ).^2 + diff( ylim ).^2 );
%for ii=1:numel( cameras )
 %   viewpoint = cameras(ii).T + range * Copy_of_getcameradirection( cameras(ii) );
  %  zlim(1) = min( zlim(1), viewpoint(3) );
   % zlim(2) = max( zlim(2), viewpoint(3) );
%end

% Move the limits in a bit since the object must be inside the circle
%xrange = diff( xlim );
%xlim = xlim + xrange/4*[1 -1];
%yrange = diff( ylim );
%ylim = ylim + yrange/4*[1 -1];

% Now perform a rough and ready space-carving to narrow down where it is
%voxels = spacecarving.makevoxels( xlim, ylim, zlim, 4000 );
%for ii=1:numel(cameras)
 %   voxels = spacecarving.carve( voxels, cameras(ii) );
%end

% Check the limits of where we found data and expand by the resolution
%xlim = [min( voxels.XData ),max( voxels.XData )] + 2*voxels.Resolution*[-1 1];
%ylim = [min( voxels.YData ),max( voxels.YData )] + 2*voxels.Resolution*[-1 1];
%zlim = [min( voxels.ZData ),max( voxels.ZData )] + 2*voxels.Resolution*[-1 1];
