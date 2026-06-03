# 基于结构感知的空间自适应混合阶变分图像平滑模型

本文为论文

《Structure-Aware Spatially Adaptive Mixed-Order Variational Model for Image Smoothing》

的 MATLAB 实现代码。

---

# 方法简介

图像平滑（Image Smoothing）的目标是在尽可能去除纹理、噪声和高频干扰的同时，完整保留图像中的真实结构边缘。

现有方法普遍存在以下问题：

- 高频纹理残留严重；
- 弱边缘容易被误平滑；
- 平坦区域容易产生阶梯效应（Staircase Artifacts）；
- 固定参数难以同时适应纹理区与结构区。

针对上述问题，本文提出一种基于结构感知的空间自适应混合阶变分模型。

该方法主要包含以下几个核心模块：

1. 多尺度结构张量分析；
2. 跨尺度结构置信度融合；
3. 空间自适应变指数 Welsch 正则化；
4. 一阶-二阶联合混合阶变分建模；
5. ADMM + IRLS 非凸优化；
6. 余弦退火（Cosine Annealing）求解策略。

最终实现：

- 强纹理抑制；
- 弱边缘保护；
- 阶梯效应抑制；
- 无需训练数据。

---

# 算法流程

<img width="628" height="1644" alt="mermaid-diagram-2026-06-03-193733" src="https://github.com/user-attachments/assets/e9ce8627-7022-4504-b68e-1c2e0cc6a700" />

---

# 文件说明

```text
README.md                          项目说明

demo.m                             演示程序

welsch_smoothing.m                 主函数

compute_base_structure_tensor.m    结构张量计算

compute_multi_scale_confidence.m   多尺度置信度融合

generate_weight_param_maps.m       参数映射生成

solve_joint_welsch_pure.m          一阶Welsch求解

solve_2nd_welsch_pure.m            二阶Welsch求解

forward_diff_fast.m                前向差分

divergence_fast.m                  散度算子

diff2_fast.m                       二阶差分

compute_dct_denominator.m          DCT频域分母

preprocess_input_image.m           图像预处理

postprocess_output.m               后处理

get_param.m                        参数读取

parse_all_params.m                 参数解析
```

---

# 运行环境

推荐版本：

```text
MATLAB R2020b及以上
```

需要工具箱：

```text
Image Processing Toolbox
```

---

# 使用方法

## 1. 下载代码

将所有文件放置于同一目录下。

例如：

```text
Project
│
├─ demo.m
├─ welsch_smoothing.m
├─ flower.jpg
└─ ...
```

---

## 2. 修改测试图片

打开 `demo.m`

相对路径：

```matlab
img = imread("flower.jpg");
```

绝对路径：

```matlab
img = imread("D:\TestImages\flower.jpg");
```

---

## 3. 运行程序

```matlab
demo
```

即可得到平滑结果。

---

# 参数说明

## 一阶项参数

```matlab
param.lambda = 3000;
```

控制纹理抑制强度。

数值越大：

- 平滑能力越强；
- 细节保留越少。

---

## 二阶项参数

```matlab
param.lambda2 = 70;
```

用于抑制阶梯效应。

设置为：

```matlab
param.lambda2 = 0;
```

表示关闭二阶项。

---

## Welsch尺度参数

```matlab
param.sigma = 20;
param.sigma_end = 0.25;
```

分别对应：

- 初始尺度
- 最终尺度

用于余弦退火调度。

---

## 自适应阶数参数

```matlab
param.p_min = 0.8;
param.p2_min = 1.0;
```

控制结构区域的稀疏程度。

数值越小：

- 保边能力越强；
- 非凸性越强。

---

## ADMM参数

```matlab
param.rho = 1.15;
param.mu = 1.15;
```

用于更新增广拉格朗日惩罚因子。

---

## 最大迭代次数

```matlab
param.itr_num = 50;
```

默认设置即可。

---

# 推荐参数

## NKS数据集

为了获得更强的纹理抑制效果：

```matlab
param.lambda = 3000;
param.lambda2 = 0;
param.sigma_start = 12;
```

关闭二阶项。

---

## SPS数据集

为了抑制阶梯效应：

```matlab
param.lambda = 4000;
param.lambda2 = 70;
param.sigma_start = 25;
```

开启二阶项。

---

