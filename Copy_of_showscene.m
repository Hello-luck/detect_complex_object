function Copy_of_showscene(cameras,voxels,angle)
%SHOWSCENE: show a carve scene, including cameras, images and the model
%
%   SHOWSCENE(CAMERAS,VOXELS) shows the specified list of CAMERAS and the
%   current model as a surface fitted around VOXELS.
%
%   Example:
%   >> camera = loadcameradata(1);
%   >> camera.Silhouette = getsilhouette( camera.Image );
%   >> voxels = carve( makevoxels(50), camera );
%   >> showscene( camera, voxels );

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $
if nargin < 3
        angle = 0; % 如果未提供 angle，则将其设置为默认值 0
end
%error( nargchk( 1, 2, nargin ) );

%% Plot each camera centre
set(gca,'DataAspectRatio',[1 1 1])
hold on

N = numel(cameras);
for ii = 1:N
    disp("ii");
    disp(ii);
    % 计算与 ii 对应的三个角度值的索引
    indexBase = (ii - 1) * 3;
    currentAngles = {angle{indexBase + 1}, angle{indexBase + 2}, angle{indexBase + 3}};

    % 使用这三个角度值调用函数
    Copy_of_showcamera(gca(), cameras(ii), currentAngles);
end
xlabel('X')
ylabel('Y')
zlabel('Z')


%% And show a surface around the object
if nargin>1 && ~isempty( voxels )
    Copy_of_showsurface( voxels );
end

%% Light the scene and adjust the view angle to make it a bit easier on 
% the eye
view(3);
grid on;
light('Position',[0 0 1]);
axis tight