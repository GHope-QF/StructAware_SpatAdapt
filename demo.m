img = imread('G:\input\00274.jpg');  


param.lambda = 2000;
param.sigma_start = 15.0;
param.sigma_end = 0.5;

% 调用平滑函数
res = welsch_smoothing(img, param);

% 显示结果
figure;
subplot(1,2,1); imshow(img); title('原图');
subplot(1,2,2); imshow(res); title('Welsch 平滑结果');