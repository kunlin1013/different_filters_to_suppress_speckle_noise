## Implement different filters to suppress speckle noise.

### Reference 
[A study of speckle noise reduction filters](https://www.semanticscholar.org/paper/A-STUDY-OF-SPECKLE-NOISE-REDUCTION-FILTERS-Shastri/d4d29b986c4ceb0c2bd476fa652068b254393f92)
[Medical image denoising by improved Kuan filter](http://advances.utc.sk/index.php/AEEE/article/view/529)

### Scalar Filters
- Mean
- Median 

### Adaptive Filters
- Frost
  - Unlike traditional linear filters (such as mean filters), the Frost filter is capable of adaptively adjusting based on the variation of pixel values within local areas of the image, thus it can better preserve edges and details in the image.
  - The Damping factor which is an exponential damping is the key factor in controlling the smoothness of the filter. When damping factor is small, the image tends to be smooth.
  ![Frost1](https://github.com/kunlin1013/different_filters_to_suppress_speckle_noise/blob/main/img/Frost1.png)
  ![Frost2](https://github.com/kunlin1013/different_filters_to_suppress_speckle_noise/blob/main/img/Frost2.png)
  ![Frost3](https://github.com/kunlin1013/different_filters_to_suppress_speckle_noise/blob/main/img/Frost3.png)
  ![LeeKuanWiener](https://github.com/kunlin1013/different_filters_to_suppress_speckle_noise/blob/main/img/LeeKuanWiener.png)
- Lee
  - The basic principle of the Lee Filter is to apply a weighted average operation on each pixel of the image, where the weights are adaptively adjusted based on the statistical properties of the neighborhood around the pixel.
  ![Lee](https://github.com/kunlin1013/different_filters_to_suppress_speckle_noise/blob/main/img/Lee.png)
- Kuan
  - Similar to the Lee and Frost Filter, the main purpose of the Kuan Filter is to reduce speckle noise in the image without overly blurring the image details and edges.
  ![Kuan](https://github.com/kunlin1013/different_filters_to_suppress_speckle_noise/blob/main/img/Kuan.png)
- Wiener
  - Statistical method: The Wiener Filter utilizes statistical information of the signal and noise, such as mean and variance, to predict the optimal filtering effect.
  - Adaptive adjustment: Based on the characteristics of the signal and noise, the Wiener Filter automatically adjusts its parameters to minimize the difference between the processed signal and the original signal.
  ![Wiener](https://github.com/kunlin1013/different_filters_to_suppress_speckle_noise/blob/main/img/Wiener.png)

### Directory structure
```
|
|-- img: Images for the README.md
|
|-- MeanFilter.m
|-- MedianFilter.m
|-- FrostFilter.m
|-- LeeFilter.m
|-- KuanFilter.m
|-- WienerFilter.m
```
