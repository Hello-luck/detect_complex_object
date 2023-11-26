
function [voxels,keep] = Copy_of_carve( voxels, camera ,angles)
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
% 
voxelFields = fieldnames(voxels);

% 显示 voxels 的所有属性名
% disp('Voxel fields:');
% disp(voxelFields);
[x,y] = Copy_of_project( camera, voxels.XData, voxels.YData, voxels.ZData ,angles);

% Clear any that are out of the image
%在我的例中中，h = 800， w = 1280, d = 1
[h,w,d] = size(camera.image); %#ok<NASGU>
keep =find( (x>=1) & (x<=w) & (y>=1) & (y<=h) );
%keep = find( (x>=1) & (x<=w) & (y>=1) & (y<=h) );
x = x(keep);
y = y(keep);




% Now clear any that are not inside the silhouette
% 这行代码用于将二维数组的行列索引转换为线性索引
ind = sub2ind( [h,w], round(y), round(x) );
keep = keep(camera.silhouette(ind) == 1);

voxels.XData = voxels.XData(keep);
voxels.YData = voxels.YData(keep);
voxels.ZData = voxels.ZData(keep);
voxels.Value = voxels.Value(keep);




