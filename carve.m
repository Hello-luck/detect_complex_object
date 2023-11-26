function [voxels,keep] = carve( voxels, camera )
%CARVE: remove voxels that are not in the silhouette
%
%   VOXELS = CARVE(VOXELS,CAMERA) carves away voxels that are not inside
%   the silhouette contained in CAMERA. The resulting voxel array is
%   returned.
%
%   [VOXELS,KEEP] = CARVE(VOXELS,CAMERA) also returns the indices of the
%   voxels that were retained.
%
%   Example:
%   >> camera = loadcameradata(1);
%   >> camera.Silhouette = getsilhouette( camera.Image );
%   >> voxels = carve( makevoxels(50), camera );
%   >> showscene( camera, voxels );
%
%   See also: LOADCAMERADATA
%             MAKEVOXELS
%             CARVEALL

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $


% Project into image
[x,y] = spacecarving.project( camera, voxels.XData, voxels.YData, voxels.ZData );


% Clear any that are out of the image
[h,w,~] = size(camera.Image); 
keep = find( (x>=1) & (x<=w) & (y>=1) & (y<=h) );
x = x(keep);
y = y(keep);
plot(im_x, im_y, 'r*'); % 使用红色星号绘制点
axis([1 h 1 w]); % 设置坐标轴范围，这里的 w 和 h 是您预期的宽度和高度
axis ij; % 用于图像坐标系，确保原点在左上角
% Now clear any that are not inside the silhouette
%ind = sub2ind( [h,w], round(y), round(x) );
%keep = keep(camera.Silhouette(ind) >= 1);

voxels.XData = voxels.XData(keep);
voxels.YData = voxels.YData(keep);
voxels.ZData = voxels.ZData(keep);
voxels.Value = voxels.Value(keep);
