# detect_complex_object
detect_complex_object boundary using matlab (can handle object with weak boundary)<br>
先检测到最稠密的地方用方框选中roi，对于roi区域：1平滑降噪，2调整卷积核让他对斜方向的边界更敏感，3标出最大的轮廓，4用strel修复空隙凹陷，5映射roi的边缘到原图像<br>
可以看到原图中有非常多的噪点和连续的白色镜头边缘反射光
<img width="560" alt="123" src="https://github.com/nitpicker55555/detect_complex_object/assets/91596298/1a34270e-7e67-4678-91eb-d97d700a52d4">

<img width="1385" alt="af7f0574797c905f9d8976dc237b006" src="https://github.com/nitpicker55555/detect_complex_object/assets/91596298/062f5372-7b50-4919-ad10-338086436c0a">
