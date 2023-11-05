# detect_complex_object
detect_complex_object boundary using matlab (can handle object with weak boundary)<br>
1. Find FOV of endoscope <br>
    1二值化，2清理小空间噪点，3将离的近的像素连在一起，4画出凸包，5椭圆近似
   （如果在椭圆近似中保留正确的凸包轮廓就好了）
   <img width="1829" alt="a7048be75074aed0195429d79f72de1" src="https://github.com/nitpicker55555/detect_complex_object/assets/91596298/c4a8d7c6-dae6-4932-8591-e935ed9230d8">

2.先检测到最稠密的地方用方框选中roi，对于roi区域：1平滑降噪，2调整卷积核让他对斜方向的边界更敏感，3标出最大的轮廓，4用strel修复空隙凹陷，5映射roi的边缘到原图像<br>
可以看到原图中有非常多的噪点和连续的白色镜头边缘反射光<br>
<img width="560" alt="123" src="https://github.com/nitpicker55555/detect_complex_object/assets/91596298/1a34270e-7e67-4678-91eb-d97d700a52d4">

<img width="1385" alt="af7f0574797c905f9d8976dc237b006" src="https://github.com/nitpicker55555/detect_complex_object/assets/91596298/062f5372-7b50-4919-ad10-338086436c0a">
