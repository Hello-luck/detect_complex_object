clc
clear
close all


load('Copy_of_cameras2.mat');

montage( cat( 4, cameras.image ) );
set( gcf(), 'Position', [100 100 600 600] )
axis off;


%for c=1:numel(cameras)
 %   cameras(c).silhouette = Copy_2_of_getsilhouette( cameras(c).image );
%end

%选择最后一幅图片来进行展示
%figure('Position',[100 100 600 300]);

%subplot(1,2,1)
%imshow( cameras(1).image );
%title( 'Original Image' )
axis off

%subplot(1,2,2)
%imshow( cameras(1).silhouette );
%title( 'Silhouette' )
axis off

%z使画面显示的效率更高
makeFullAxes( gcf );

%确定要雕刻的模型的边界框（x、y 和 z 限制）。 这允许构建初始体素体积。
[xlim,ylim,zlim] = Copy_of_findmodel( cameras );

% 这将创建一个规则的三维网格，以便雕刻。
% OctTrees 和其他细化表示法在内存和计算时间上都能提供更好的效率
% makevoxels创建基本的体素网格，准备雕刻
voxels = Copy_of_makevoxels( xlim, ylim,  [-40,50], 20000);
starting_volume = numel( voxels.XData );
sliderDemo2(cameras,voxels);
% Show the whole scene
% sliderDemo(cameras,voxels);
% function createSliderForAngle(cameras,voxels)
%     % 初始化 angle 的值
%     angle = 1;
% 
%     % 创建一个图形窗口
%     fig = figure('Position', [100, 100, 600, 400]);
% 
%     % 创建显示区域
%     ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);
% 
%     % 创建滑块
%     slider = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [150, 50, 300, 20], ...
%                        'value', angle, 'min', 1, 'max', 360, ...
%                        'SliderStep', [1/359, 10/359], 'Callback', @sliderCallback);
% 
%     % 创建用于显示滑块值的文本框
%     sliderValueDisplay = uicontrol('Parent', fig, 'Style', 'text', 'Position', [460, 45, 50, 20], ...
%                                    'String', num2str(angle));
% 
%     % 初始显示
%     updateDisplay(angle);
% 
%     % 滑块的回调函数
%     function sliderCallback(src, ~)
%         angle = get(src, 'Value');
%         set(sliderValueDisplay, 'String', num2str(round(angle))); % 更新文本框内容
%         updateDisplay(angle);
%     end
% 
%     % 更新显示的函数
%     function updateDisplay(angle)
%         % 清除当前轴
%         cla(ax);
% 
%         % 调用你的显示函数
%         Copy_of_showscene(cameras, voxels, angle);
%     end
% end
% 调用该函数以创建图形界面

%figure(4)
%Copy_of_showcamera(cameras)

% 开始雕刻第一个
% 创建一个新窗口
% function sliderDemo(cameras,voxels)
%     % 初始化 angel 的值
%     angel = 1;
% % 创建一个图形窗口
% fig = figure('Position', [100, 100, 900, 800]); % 增加窗口的高度以容纳两行图表
% 
% % 创建第一行的两个绘图区域
% ax1 = axes('Parent', fig, 'Position', [0.1, 0.55, 0.35, 0.4]); % 第一行，第一个位置
% ax2 = axes('Parent', fig, 'Position', [0.55, 0.55, 0.35, 0.4]); % 第一行，第二个位置
% 
% % 创建第二行的两个绘图区域
% ax3 = axes('Parent', fig, 'Position', [0.1, 0.1, 0.35, 0.4]); % 第二行，第一个位置
% ax4 = axes('Parent', fig, 'Position', [0.55, 0.1, 0.35, 0.4]); % 第二行，第二个位置
% 
%     % 创建滑块
%     slider = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [400, 20, 300, 20], ...
%                        'value', angel, 'min', 1, 'max', 450);
%     addlistener(slider, 'Value', 'PostSet', @(src,evt) updateDisplay(voxels,cameras));
% 
%     % 初始显示
%     %updateDisplay(voxels,cameras);
% 
%     % 更新显示的回调函数
%     function updateDisplay(voxelsLocal,cameras)
%         voxelsCopy = voxelsLocal; % 创建 voxels 的副本
%         angel = get(slider, 'Value');
% 
%         % 使用第一个相机对体素进行雕刻并显示结果
%         axes(ax1); % 指定当前绘图区域为 ax1
%          cla(ax1); 
%         [voxels1, keep] = Copy_of_carve(voxelsCopy, cameras(1), angel);
%         Copy_of_showscene(cameras(1), voxels1, angel);
%         title('1 camera');
% 
%         % 使用第二个相机对体素进行雕刻并显示结果
%         axes(ax2); % 指定当前绘图区域为 ax2
%          cla(ax2); 
%         [voxels2, keep] = Copy_of_carve(voxelsCopy, cameras(2), angel);
%         Copy_of_showscene(cameras(2), voxels2, angel);
%         title('2 camera');
% 
%         % 使用第三个相机对体素进行雕刻并显示结果
%         axes(ax3); % 指定当前绘图区域为 ax3
%          cla(ax3); 
%         [voxels3, keep] = Copy_of_carve(voxelsCopy, cameras(3), angel);
%         Copy_of_showscene(cameras(3), voxels3, angel);
%         title('3 camera');
% 
%          axes(ax4); % 指定当前绘图区域为 ax3
%          cla(ax4); 
%         Copy_of_showscene(cameras, voxels, angel);
%         title('3 camera');
%     end
% end


function sliderDemo2(cameras, voxels)
    % 初始化角度值
    angle1a = 1; angle2a = 1; angle3a = 1;
    angle1b = 1; angle2b = 1; angle3b = 1;
        angle1c = 1; angle2c = 1; angle3c = 1;
    % 创建一个图形窗口
    fig = figure('Position', [100, 100, 900, 800]);

    % 创建四个绘图区域
    ax1 = axes('Parent', fig, 'Position', [0.1, 0.55, 0.35, 0.4]);
    ax2 = axes('Parent', fig, 'Position', [0.55, 0.55, 0.35, 0.4]);
    ax3 = axes('Parent', fig, 'Position', [0.1, 0.1, 0.35, 0.4]);
    ax4 = axes('Parent', fig, 'Position', [0.55, 0.1, 0.35, 0.4]);
ax5 = axes('Parent', fig, 'Position', [0.1, 0.05, 0.8, 0.2]);

    % 创建第一个图表的三个滑块
    slider1a = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [100, 750, 200, 20], ...
                         'value', angle1a, 'min', 1, 'max', 450);
    slider1b = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [100, 720, 200, 20], ...
                         'value', angle1b, 'min', 1, 'max', 450);
    slider1c = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [100, 690, 200, 20], ...
                         'value', angle1c, 'min', 1, 'max', 450);

    % 创建第二个图表的三个滑块
    slider2a = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [400, 750, 200, 20], ...
                         'value', angle2a , 'min', 1, 'max', 450);
    slider2b = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [400, 720, 200, 20], ...
                         'value', angle2b, 'min', 1, 'max', 450);
    slider2c = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [400, 690, 200, 20], ...
                         'value', angle2c, 'min', 1, 'max', 450);

    % 创建第三个图表的三个滑块
    slider3a = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [700, 750, 200, 20], ...
                         'value', angle3a, 'min', 1, 'max', 450);
    slider3b = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [700, 720, 200, 20], ...
                         'value', angle3b, 'min', 1, 'max', 450);
    slider3c = uicontrol('Parent', fig, 'Style', 'slider', 'Position', [700, 690, 200, 20], ...
                         'value', angle3c, 'min', 1, 'max', 450);

    % 添加滑块监听器
    addlistener(slider1a, 'Value', 'PostSet', @(src, evt) updateDisplay(voxels, cameras));
    addlistener(slider1b, 'Value', 'PostSet', @(src, evt) updateDisplay(voxels, cameras));
    addlistener(slider1c, 'Value', 'PostSet', @(src, evt) updateDisplay(voxels, cameras));
        addlistener(slider2a, 'Value', 'PostSet', @(src, evt) updateDisplay(voxels, cameras));
    addlistener(slider2b, 'Value', 'PostSet', @(src, evt) updateDisplay(voxels, cameras));
    addlistener(slider2c, 'Value', 'PostSet', @(src, evt) updateDisplay(voxels, cameras));
        addlistener(slider3a, 'Value', 'PostSet', @(src, evt) updateDisplay(voxels, cameras));
    addlistener(slider3b, 'Value', 'PostSet', @(src, evt) updateDisplay(voxels, cameras));
    addlistener(slider3c, 'Value', 'PostSet', @(src, evt) updateDisplay(voxels, cameras));
    % ...（为其他滑块添加相同的监听器）

    % 更新显示的回调函数
    function updateDisplay(voxelsLocal, cameras)
        voxelsCopy = voxelsLocal;
% 获取第一个图表的滑块值
angles_sum = {
    get(slider1a, 'Value'), get(slider2a, 'Value'), get(slider3a, 'Value'), 
    get(slider1b, 'Value'), get(slider2b, 'Value'), get(slider3b, 'Value'),
    get(slider1c, 'Value'), get(slider2c, 'Value'), get(slider3c, 'Value')
};
angles1 = {
    get(slider1a, 'Value'), get(slider1b, 'Value'), get(slider1c, 'Value') 
  
};
angles2 = {
 
    get(slider2a, 'Value'), get(slider2b, 'Value'), get(slider2c, 'Value')

};
angles3 = {
 
    get(slider3a, 'Value'), get(slider3b, 'Value'), get(slider3c, 'Value')
};
disp("angles_sum");
disp(angles_sum);

        % 更新第一个图表的显示
        axes(ax1);
        cla(ax1);
                [voxels1, keep] = Copy_of_carve(voxelsCopy, cameras(1), angles1);
        Copy_of_showscene(cameras(1), voxels1, angles1);
        % ...（调用适当的函数来展示基于 angle1, angle2, angle3 的结果）
        title('Camera 1');

        % 更新第二个图表的显示
        axes(ax2);
        cla(ax2);
                        [voxels2, keep] = Copy_of_carve(voxels1, cameras(2), angles2);
        Copy_of_showscene(cameras(2), voxels2, angles2);
        % ...（类似地更新，可能需要获取 slider2a, slider2b, slider2c 的值）
        title('Camera 2');

        % 更新第三个图表的显示
        axes(ax3);
        cla(ax3);
                        [voxels3, keep] = Copy_of_carve(voxels2, cameras(3), angles3);
        Copy_of_showscene(cameras(3), voxels3, angles3);
        % ...（同上，使用 slider3a, slider3b, slider3c 的值）
        title('Camera 3');

        % 更新第四个图表的显示
        axes(ax4);
        cla(ax4);
                       
        Copy_of_showscene(cameras, voxels3, angles_sum);
        % ...（这个可能使用原始的 angle 值或者一个新的逻辑）
        title('All Cameras');

    end
end


%subplot(1,2,2)
%Copy_of_showsurface( voxels )
%title( 'Result after 1 carving' )

%voxels = Copy_of_carve( voxels, cameras(3) );
%voxels = Copy_of_carve( voxels, cameras(1) );

% Show Result





















