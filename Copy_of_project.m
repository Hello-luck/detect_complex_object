function [im_x, im_y] = Copy_of_project( camera, world_X, world_Y, world_Z ,angles)
%PROJECT: project a 3D point into an angles{1}image
%
%   [IM_X,IM_Y] = PROJECT(CAMERA,WORLD_X,WORLD_Y,WORLD_Z) projects one or
function P = createModifiedProjectionMatrix(K, R, t, angles)
    % 创建投影矩阵，并对R进行小幅度的旋转
    % 输入参数：
    % K - 相机的内参矩阵
    % R - 相机的旋转矩阵
    % t - 相机的平移向量
    % angle - 旋转的角度（弧度）
    % axis - 旋转轴（'x', 'y', 或 'z'）

    % 生成绕指定轴的旋转矩阵

    R_deltax = [1, 0, 0; 0, cos(angles{1} * pi / 180), -sin(angles{1} * pi / 180); 0, sin(angles{1} * pi / 180), cos(angles{1} * pi / 180)];

    R_deltay = [cos(angles{2} * pi / 180), 0, sin(angles{2} * pi / 180); 0, 1, 0; -sin(angles{2} * pi / 180), 0, cos(angles{2} * pi / 180)];

    R_deltaz = [cos(angles{3} * pi / 180), -sin(angles{3} * pi / 180), 0; sin(angles{3} * pi / 180), cos(angles{3} * pi / 180), 0; 0, 0, 1];




    % 应用小幅度旋转
    R_modified = R * R_deltax*R_deltay*R_deltaz;

    % 构建相机的外参矩阵
    Rt = [R_modified, t(:)]; % 确保 t 是列向量

    % 计算投影矩阵
    P = K * Rt;
end

K = camera.K; % 你的内参矩阵
R = camera.R; % 你的原始旋转矩阵
t = camera.t; % 你的平移向量
% angle = angle_value * pi / 180; % 将角度转换为弧度
% axis = 'x'; % 选择旋转轴

P = createModifiedProjectionMatrix(K, R, t, angles);
z = P(3,1) * world_X ...
    + P(3,2) * world_Y ...
    + P(3,3) * world_Z ...
    + P(3,4);
im_y = round( (P(2,1) * world_X ...
    + P(2,2) * world_Y ...
    + P(2,3) * world_Z ...
    + P(2,4)) ./ z);
im_x = round( (P(1,1) * world_X ...
    + P(1,2) * world_Y ...
    + P(1,3) * world_Z ...
    + P(1,4)) ./ z);




end